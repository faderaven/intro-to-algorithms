<TeXmacs|1.99.6>

<style|generic>

<\body>
  <section*|D.1-2>

  Prove that (<em|AB>)<rsup|T>=<em|B><rsup|T><em|A><rsup|T> and that
  <em|A><rsup|T><em|A> is always a symmetric matrix.

  <subsubsection*|1. Prove (<em|AB>)<rsup|T>=<em|B><rsup|T><em|A><rsup|T>>

  Assume <strong|<em|<strong|>A>> and <em|<strong|B>> is compatible, set

  <\indent>
    <em|<strong|A>> = <with|font-base-size|10|<math|<with|font-base-size|10|<large|<matrix|<tformat|<table|<row|<cell|a<rsub|11>>|<cell|a<rsub|12>>|<cell|\<cdots\>>|<cell|a<rsub|1k><wide||\<wide-bar\>>>>|<row|<cell|a<rsub|21>>|<cell|a<rsub|22>>|<cell|\<cdots\>>|<cell|a<rsub|2k>>>|<row|<cell|\<vdots\>>|<cell|\<vdots\>>|<cell|\<ddots\>>|<cell|>>|<row|<cell|a<rsub|i1>>|<cell|a<rsub|i2>>|<cell|>|<cell|a<rsub|i
    k>>>>>>>>>> , \ <em|<strong|B>> = <large|<with|font-base-size|10|<math|<with|font-base-size|10|<matrix|<tformat|<cwith|1|1|4|4|cell-halign|r>|<table|<row|<cell|b<rsub|11>>|<cell|b<rsub|12>>|<cell|\<cdots\>>|<cell|b<rsub|1j>>>|<row|<cell|b<rsub|21>>|<cell|b<rsub|22>>|<cell|\<cdots\>>|<cell|b<rsub|2j>>>|<row|<cell|\<vdots\>>|<cell|\<vdots\>>|<cell|\<ddots\>>|<cell|>>|<row|<cell|b<rsub|k1>>|<cell|b<rsub|k2>>|<cell|>|<cell|b<rsub|k
    j>>>>>>>>>><space|1em> then

    (<em|<strong|AB>>)<math|<rsup|T>> = <math|<with|font-base-size|14|<with|font-base-size|10|<very-large|<large|<matrix|<tformat|<table|<row|<cell|<above|<below|<big|sum>|n=1>|k>a<rsub|1n>b<rsub|n1>>|<cell|<below|<above|<big|sum>|k>|n=1>a<rsub|1n>b<rsub|n2>>|<cell|\<cdots\>>|<cell|<below|<above|<big|sum>|k>|n=1>a<rsub|1n>b<rsub|n
    j>>>|<row|<cell|<above|<below|<big|sum>|n=1>|k>a<rsub|2n>b<rsub|n1>>|<cell|<above|<below|<big|sum>|n=1>|k>a<rsub|2n>b<rsub|n2>>|<cell|\<cdots\>>|<cell|<above|<below|<big|sum>|n=1>|k>a<rsub|2n>b<rsub|n
    j>>>|<row|<cell|\<vdots\>>|<cell|\<vdots\>>|<cell|\<ddots\>>|<cell|>>|<row|<cell|<above|<below|<big|sum>|n=1>|k>a<rsub|i
    n>b<rsub|n1>>|<cell|<above|<below|<big|sum>|n=1>|k>a<rsub|i
    n>b<rsub|n2>>|<cell|>|<cell|<below|<above|<big|sum>|k>|n=1>a<rsub|i
    n>b<rsub|n j>>>>>>>>><rsup|T>>> = \ <math|<large|<matrix|<tformat|<table|<row|<cell|<below|<above|<big|sum>|k>|n=1>a<rsub|1n>b<rsub|n1>>|<cell|<above|<below|<big|sum>|n=1>|k>a<rsub|2n>b<rsub|n1>>|<cell|\<cdots\>>|<cell|<above|<below|<big|sum>|n=1>|k>a<rsub|i
    n>b<rsub|n1>>>|<row|<cell|<below|<above|<big|sum>|k>|n=1>a<rsub|1n>b<rsub|n2>>|<cell|<above|<below|<big|sum>|n=1>|k>a<rsub|2n>b<rsub|n2>>|<cell|\<cdots\>>|<cell|<above|<below|<big|sum>|n=1>|k>a<rsub|i
    n>b<rsub|n2>>>|<row|<cell|\<vdots\>>|<cell|\<vdots\>>|<cell|\<ddots\>>|<cell|>>|<row|<cell|<below|<above|<big|sum>|k>|n=1>a<rsub|1n>b<rsub|n
    j>>|<cell|<above|<below|<big|sum>|n=1>|k>a<rsub|2n>b<rsub|n
    j>>|<cell|>|<cell|<below|<above|<big|sum>|k>|n=1>a<rsub|i n>b<rsub|n
    j>>>>>>>>
  </indent>

  set

  <\indent>
    <em|<strong|B<math|<rsup|T>>>> = <math|<large|<matrix|<tformat|<table|<row|<cell|b<rsub|11>>|<cell|b<rsub|21>>|<cell|\<cdots\>>|<cell|b<rsub|k1>>>|<row|<cell|b<rsub|12>>|<cell|b<rsub|22>>|<cell|\<cdots\>>|<cell|b<rsub|k2>>>|<row|<cell|\<vdots\>>|<cell|\<vdots\>>|<cell|\<ddots\>>|<cell|>>|<row|<cell|b<rsub|1j>>|<cell|b<rsub|2j>>|<cell|>|<cell|b<rsub|k
    j>>>>>>>><space|2em><em|<strong|A<math|<rsup|T>>>> =
    <math|<large|<matrix|<tformat|<table|<row|<cell|a<rsub|11>>|<cell|a<rsub|21>>|<cell|\<cdots\>>|<cell|a<rsub|i1>>>|<row|<cell|a<rsub|12>>|<cell|a<rsub|22>>|<cell|\<cdots\>>|<cell|a<rsub|i2>>>|<row|<cell|\<vdots\>>|<cell|\<vdots\>>|<cell|\<ddots\>>|<cell|>>|<row|<cell|a<rsub|1k>>|<cell|a<rsub|2k>>|<cell|>|<cell|a<rsub|i
    k>>>>>>>><space|2em>then

    <em|<strong|B<math|<rsup|T>A<rsup|T>>>> =
    <math|<large|<matrix|<tformat|<table|<row|<cell|<below|<above|<big|sum>|k>|n=1>a<rsub|1n>b<rsub|n1>>|<cell|<below|<above|<big|sum>|k>|n=1>a<rsub|2n>b<rsub|n1>>|<cell|\<cdots\>>|<cell|<below|<above|<big|sum>|k>|n=1>a<rsub|i
    n>b<rsub|n1>>>|<row|<cell|<below|<above|<big|sum>|k>|n=1>a<rsub|1n>b<rsub|n2>>|<cell|<below|<above|<big|sum>|k>|n=1>a<rsub|2n>b<rsub|n2>>|<cell|\<cdots\>>|<cell|<below|<above|<big|sum>|k>|n=1>a<rsub|i
    n>b<rsub|n2>>>|<row|<cell|\<vdots\>>|<cell|\<vdots\>>|<cell|\<ddots\>>|<cell|>>|<row|<cell|<below|<above|<big|sum>|k>|n=1>a<rsub|1n>b<rsub|n
    j>>|<cell|<below|<above|<big|sum>|k>|n=1>a<rsub|2n>b<rsub|n
    j>>|<cell|>|<cell|<below|<above|<big|sum>|k>|n=1>a<rsub|i n>b<rsub|n
    j>>>>>>>>
  </indent>

  so, <strong|(<em|AB>)<rsup|T>=<em|B><rsup|T><em|A><rsup|T>>

  \;

  \;
</body>

<initial|<\collection>
</collection>>

<\references>
  <\collection>
    <associate|auto-1|<tuple|?|1>>
    <associate|auto-2|<tuple|?|1>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|toc>
      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|D.1-2>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-1><vspace|0.5fn>

      <with|par-left|<quote|2tab>|1. Prove
      (<with|font-shape|<quote|italic>|AB>)<rsup|T>=<with|font-shape|<quote|italic>|B><rsup|T><with|font-shape|<quote|italic>|A><rsup|T>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-2>>
    </associate>
  </collection>
</auxiliary>