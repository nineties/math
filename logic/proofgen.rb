#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#
# Author: Koichi Nakamura (koichi.nakamur@gmail.com)
# 
# Proof Generator for Formal Predicate Logic (Hilbert-style)
#

## constructors
def neg(p); [:NEG, p] end
def imp(p, q); [:IMP, p, q] end
def or(p, q); imp(neg(p), q) end
def and(p, q); neg(imp(p, neg(q))) end
def forall(x,p); [:FORALL, x, p] end
def exists(x,p); neg(forall(x,neg(p))) end
def prop(p, x); [:PROP, p, x] end
def bot(p); neg(imp(p, p)) end

def neg?(p); p.is_a?(Array) && p[0] == :NEG end
def imp?(p); p.is_a?(Array) && p[0] == :IMP end
def forall?(p); p.is_a?(Array) && p[0] == :FORALL end

## pretty printer
def formula_to_s_loop(p)
    return p.to_s if p.is_a?(Symbol)
    case p[0]
    when :NEG
        "￢#{formula_to_s_loop(p[1])}"
    when :IMP
        "(#{formula_to_s_loop(p[1])}→#{formula_to_s_loop(p[2])})"
    when :FORALL
        "∀#{p[1]}#{formula_to_s_loop(p[2])}"
    when :PROP
        "#{p[1]}(#{p[2]})"
    end
end
def formula_to_s(p)
    return formula_to_s_loop(p) unless p.is_a?(Array) && p[0] == :IMP
    "#{formula_to_s_loop(p[1])}→#{formula_to_s_loop(p[2])}"
end

def print_proof(proof)
    puts "=== proof of #{formula_to_s(proof[-1])} ==="
    proof.each_with_index do |p, i|
        if ax1?(p)
            comment = "Ax1"
        elsif ax2?(p)
            comment = "Ax2"
        elsif ax3?(p)
            comment = "Ax3"
        elsif ax4?(p)
            comment = "Ax4"
        elsif forall?(p)
            comment = "GEN"
            used[i-1] = true
        else
            (i-1).downto(0) do |j|
                next unless imp?(proof[j]) && proof[j][2] == p
                (i-1).downto(0) do |k|
                next unless proof[k] == proof[j][1]
                comment = "#{k},#{j},MP"
                end
            end
        end
        puts "#{[i]}\t#{formula_to_s(p)} (#{comment})"
    end
end

## Simplification
def simplify(proof)
    p = proof[-1]
    0.upto(proof.size-2) do |i|
        if proof[i] == p
            proof = proof[0..i]
            break
        end
    end
    proof.uniq!

    # fixme ....
    loop do
        used = [false] * proof.size
        proof.each_with_index do |p, i|
            if forall?(p)
                comment = "GEN"
                used[i-1] = true
            elsif !ax?(p)
                (i-1).downto(0) do |j|
                    next unless imp?(proof[j]) && proof[j][2] == p
                    (i-1).downto(0) do |k|
                    next unless proof[k] == proof[j][1]
                    used[j] = used[k] = true
                    end
                end
            end
        end
        new_proof = []
        proof.each_with_index do |p, i|
            new_proof << p if used[i]
        end
        new_proof << p
        return new_proof if new_proof.size == proof.size
        proof = new_proof
    end
end

## substitution of free variable
def subst(p, x, t)
    return p if p.is_a?(Symbol)
    case p[0]
    when :NEG
        q = subst(p[1], x, t)
        q.equal?(p[1]) ? p : neg(q)
    when :IMP
        q = subst(p[1], x, t)
        r = subst(p[2], x, t)
        if q.equal?(p[1]) && r.equal?(p[2])
            return p
        else
            imp(q, r)
        end
    when :FORALL
        return p if p[1] == x
        q = subst(p[2], x, t)
        if p[1] == t && !q.equals(p[2])
            raise "Substitution error"
        else
            forall(p[1],q)
        end
    when :PROP
        return p if p[2] != x
        prop(p[1], t)
    end
end

## Axioms
def ax1(p,q); imp(p, imp(q, p)) end
def ax2(p,q,r); imp(imp(p, imp(q, r)), imp(imp(p, q), imp(p, r))) end
def ax3(p,q); imp(imp(neg(p), neg(q)), imp(q, p)) end
def ax4(p,x,t); imp(forall(x, p), subst(p, x, t)) end

def ax1?(p)
    imp?(p) && imp?(p[2]) && p[1] == p[2][2]
end
def ax2?(p)
    imp?(p) && imp?(p[1]) && imp?(p[1][2]) && imp?(p[2]) && imp?(p[2][1]) &&
        imp?(p[2][2]) && p[1][1] == p[2][1][1] && p[1][1] == p[2][2][1] && 
        p[1][2][1] == p[2][1][2] && p[1][2][2] == p[2][2][2]
end
def ax3?(p)
    imp?(p) && imp?(p[1]) && neg?(p[1][1]) && neg?(p[1][2]) &&
        imp?(p[2]) && p[1][1][1] == p[2][2] && p[1][2][1] == p[2][1]
end
def ax4?(p)
    imp?(p) && forall?(p[1]) && same_form(p[1][1], p[1][2], p[2])
end
def same_form(x,p,q)
    return false if p.class != q.class
    if p.is_a?(Symbol)
        return p == q
    end
    return false if p[0] != q[0]
    case p[0]
    when :NEG
        same_form(x, p[1], q[1])
    when :IMP
        a = same_form(x, p[1], q[1])
        b = same_form(x, p[2], q[2])
        return a if a && a==b
        return b if a == true
        return a if b == true
        return false
    when :FORALL
        same_form(x, p[2], q[2])
    when :PROP
        return false if p[1] != q[1]
        return q[2] if p[2] == x
        return false if p[2] != q[2]
        return true
    end
end
def ax?(p)
    ax1?(p) || ax2?(p) || ax3?(p) || ax4?(p)
end

## Modus ponens and generalization
def mp(proof)
    p = proof[-1]
    if p.is_a?(Array) && p[0] == :IMP
        # lookup hypothesis
        if proof.member?(p[1])
            proof << p[2]
            return proof
        else
            raise "Could not find #{formula_to_s(p[1])}"
        end
    end
    raise "Invalid application of MP for #{formula_to_s(p)}"
end
def gen(proof, t, x)
    p = proof[-1]
    proof << forall(x, subst(p, t, x))
end

## identity theorem
# p →p
def identity(p)
    proof = []
    proof << ax1(p, p)
    proof << ax1(p, imp(p, p))
    proof << ax2(p, imp(p, p), p)
    mp(proof)
    mp(proof)
end

## Meta theorems

# detection theorem
# generate proof of ├ p→q from proof of p ├ q
def meta_deduction1(p, proof, hypo=[])
    q = proof[-1]
    if ax?(q) || hypo.member?(q)
        return [q, ax1(q, p), imp(p, q)]
    elsif q == p
        return identity(p)
    else
        n = proof.size
        (n-1).downto(0) do |i|
            next unless imp?(proof[i]) && proof[i][2] == q
            pi = proof[i]
            (n-1).downto(0) do |j|
                next unless proof[j] == proof[i][1]
                pj = proof[j]
                proof1 = meta_deduction1(p, proof[0..j], hypo)
                proof2 = meta_deduction1(p, proof[0..i], hypo)
                proof = proof1 + proof2
                proof << ax2(p, pj, q)
                mp(proof)
                mp(proof)
                return proof
            end
        end

        if forall?(q)
            x = q[1]
            (n-1).downto(0) do |i|
                t = same_form(x, q[2], proof[i])
                next unless t
                pi = proof[i]
                proof = meta_deduction1(p, proof[0..i], hypo)
                proof = meta_deduction2(p, proof)
                gen(proof, t, x)
                proof = meta_deduction1(p, proof)
                return proof
            end
        end

        raise "ERROR #{formula_to_s(proof[-1])}"
    end
end
# generate proof of p ├ q from proof of ├ p→q
def meta_deduction2(p, proof)
    proof.unshift(p)
    mp(proof)
end

# ├ ￢p →(p → q)
def contradiction1(p, q)
    proof = []
    proof << ax3(q, p)
    proof << ax1(neg(p), neg(q))
    proof << ax1(imp(imp(neg(q), neg(p)), imp(p, q)), neg(p)) 
    mp(proof)
    proof << ax2(neg(p), imp(neg(q), neg(p)), imp(p, q))
    mp(proof)
    mp(proof)
end

# ├ ￢￢p →p
def double_negative_elimination(p)
    proof = contradiction1(neg(p), neg(neg(neg(p))))
    proof = meta_deduction2(neg(neg(p)), proof)
    proof << ax3(p, neg(neg(p)))
    mp(proof)
    mp(proof)
    meta_deduction1(neg(neg(p)), proof)
end

# ├ P →￢￢P
def double_negative_insertion(p)
    proof = [p]
    proof = meta_double_negative_insertion(proof)
    meta_deduction1(p, proof)
end

# ├ ￢￢P => ├ P
def meta_double_negative_elimination(proof1)
    p = proof1[-1][1][1]
    proof2 = double_negative_elimination(p)
    proof = proof1 + proof2
    mp(proof)
end

# ├ P => ├ ￢￢P
def meta_double_negative_insertion(proof1)
    p = proof1[-1]
    proof2 = double_negative_elimination(neg(p))
    proof = proof1 + proof2
    proof << ax3(neg(neg(p)), p)
    mp(proof)
    mp(proof)
end

# ￢P ├ ￢(Q→Q) => ├ P
def meta_contradiction1(p, proof)
    q = proof[-1][1][1]
    proof = meta_deduction1(neg(p), proof)
    proof += identity(q)
    proof << ax3(p, imp(q, q))
    mp(proof)
    mp(proof)
end

# ├ P => ￢P ├ ￢(Q→Q)
def meta_contradiction2(q, proof1)
    p = proof1[-1]
    proof2 = contradiction1(p, bot(q))
    proof2 = meta_deduction2(neg(p), proof2)
    proof = proof1 + proof2
    mp(proof)
end

# ├ ￢P→￢Q => P→Q
def meta_contraposition1(proof)
    p = proof[-1][1][1]
    q = proof[-1][2][1]
    proof << ax3(q, p)
    mp(proof)
end

# ├ P→Q => ├ ￢Q→￢P
def meta_contraposition2(proof1)
    p = proof1[-1][1]
    q = proof1[-1][2]
    proof2 = double_negative_elimination(p)
    proof2 = meta_deduction2(neg(neg(p)), proof2)
    proof = proof2 + proof1
    mp(proof)
    proof = meta_double_negative_insertion(proof)
    proof = meta_deduction1(neg(neg(p)), proof)
    proof << ax3(neg(p), neg(q))
    mp(proof)
end

# ├ P→Q, ￢P→Q => ├ Q
def meta_dilemma(proof1, proof2)
    p = proof1[-1][1]
    q = proof1[-1][2]
    proof1 = meta_contraposition2(proof1)
    proof2 = meta_contraposition2(proof2)
    proof1 = meta_deduction2(neg(q), proof1)
    proof2 = meta_deduction2(neg(q), proof2)
    proof2 = meta_double_negative_elimination(proof2)
    proof = proof1 + proof2
    proof += contradiction1(p, bot(:P))
    mp(proof)
    mp(proof)
    meta_contradiction1(q, proof)
end


# ├ P, Q => ├ P and Q
def meta_insert_and(proof1, proof2)
    p = proof1[-1]
    q = proof2[-1]
    proof = proof1 + proof2 + [neg(neg(imp(p, neg(q))))]
    proof = meta_double_negative_elimination(proof)
    mp(proof)
    proof += contradiction1(q, bot(:P))
    mp(proof)
    mp(proof)
    proof = meta_contradiction1(neg(imp(p, neg(q))), proof)
end

# ├ P(t) => ├ ∀xP(x)
def meta_forall_gen(proof,t,x)
    gen(proof, t, x)
end

# ├ P(t) => ├ ∃xP(x)
def meta_exists_gen(proof1,t,x)
    p = proof1[-1]
    proof2 = []
    proof2 << ax4(neg(subst(p,t,x)), x, t)
    proof2 = meta_contraposition2(proof2)
    proof1 = meta_double_negative_insertion(proof1)
    mp(proof1 + proof2)
end


### Example1 ###
## proof of ├ (P→￢￢P)∧(￢￢→P)
#proof1 = double_negative_insertion(:P)
#proof2 = double_negative_elimination(:P)
#proof = meta_insert_and(proof1, proof2)
#proof = simplify(proof)
#print_proof proof

### Example2 ###
## proof of ├ ∀xP(x) →∃xP(x)
proof = [forall(:x, prop(:P, :x))]
proof << ax4(prop(:P, :x), :x, :t)
mp(proof)
proof = meta_exists_gen(proof,:t,:x)
proof = meta_deduction1(forall(:x, prop(:P, :x)), proof)
print_proof simplify(proof)
