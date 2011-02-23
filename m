From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Tue, 22 Feb 2011 18:05:20 -0600
Subject: [Ocfs2-devel] [PATCH] Treat writes as new when holes span
 across page boundaries
In-Reply-To: <20110222233417.GC28774@noexit>
References: <AANLkTi=pEu5y4=kjG1YoLR+YCd7Ak21QaFQz=AR3dffX@mail.gmail.com>
	<20110220070953.GC17784@noexit>
	<AANLkTinuhh9nF=6NQbe81NbE0K95huVtdDdC9Gb2pU=5@mail.gmail.com>
	<20110221020856.GL17784@noexit>
	<AANLkTimXr0rA5FV_ep-y9uetUVcD3w+9MuTZeBnLXDvG@mail.gmail.com>
	<20110222083648.GC30966@noexit>
	<AANLkTi=+vK_17n-ENMznWbYKBZcZ0v1U0ptgv8qThkUv@mail.gmail.com>
	<20110222213927.GA28774@noexit> <20110222215428.GB28774@noexit>
	<AANLkTikByGbpDyDmbM7kNV-ZAt1Ts5BzbM0Ospi=o8Ki@mail.gmail.com>
	<20110222233417.GC28774@noexit>
Message-ID: <AANLkTik3387QOadM+-7FaXLT90ednn6+=oDfiyzjt=Tv@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Feb 22, 2011 at 5:34 PM, Joel Becker <jlbec@evilplan.org> wrote:
> On Tue, Feb 22, 2011 at 04:09:47PM -0600, Goldwyn Rodrigues wrote:
>> On Tue, Feb 22, 2011 at 3:54 PM, Joel Becker <jlbec@evilplan.org> wrote:
>> > On Tue, Feb 22, 2011 at 01:39:28PM -0800, Joel Becker wrote:
>> > ? ? ? ?Looking some more. ?ocfs2_zero_tail() is supposed to handle
>> > this, isn't it? ?ocfs2_write_begin_nolock() calls ocfs2_zero_tail(pos),
>> > which calls ocfs2_zero_extend(pos), which works up to
>> > ocfs2_clusters_for_bytes(pos). ?Doesn't this include your cluster?
>> > Shouldn't the page already be loaded into the pagecache with zeros?
>> >
>> >
>>
>> Din't you discard that idea in my previous attempt? ;)
>
> ? ? ? ?I might have ;-) ?I'm reloading state here, so I might be coming
> back to something you've already seen. ?I'm trying to ask questions that
> make both of us come to the same understanding. ?So my apologies if I
> didn't get what you were saying before.
> ? ? ? ?For example, I thought you were saying that a write from 0 to
> 1023 (new i_size of 1024), with a blocksize of 4K and a clustersize of
> 8K, should zero from 1024 to 8191. ?That is, zeroing the entire cluster
> at allocation time, even though the second block does not contain
> i_size. ?My contention is that 1024 to 4095 should be zeroed for this
> write. ?We would only zero the second block when the file is later
> extended past 4096.
> ? ? ? ?I may have been confused because ocfs2_zero_extend() only used
> to matter for nonsparse, where this behavior was different. ?Which of
> the above did you mean?
>

Hmm, explanation follows.. let me know if you still have questions.

>> On a serious note, no it doesn't because zero_start and zero_to_size
>> are the same when pos is on a block boundary and hence the loop does
>> not execute.
>
> ? ? ? ?If they are the same (i_size == pos), there is no hole. ?I don't
> see how there is a problem.
>
>

Not now, but it may in the future and that is the problem.

So consider your case of usual parameters, but i_size=4096.
Now you append 32 bytes of data to it, so pos = i_size = 4096
and len=32
write(fd, 32 bytes of data);

In this case, zero_start and zero_to_size in zero_extend_file are both
4096 and it will not zero this page in ocfs2_zero_extend.

After the write, i_size=4128.

Now lseek 512 bytes -
lseek(fd, 512, SEEKCUR);


..and write 4096 bytes again.
write(fd, 4096bytes of data);

pos=4640 len=4096 bytes, and after the transaction i_size=8736.

i_size is beyond 8192 now

Hole between 4128-4640 was never zeroed and carries junk. Does that
make sense or am I doing the math wrong here?

Linux does not zero the rest of the page until the page with i_size is
written. Since i_size has been beyond 8192, Linux never got a chance
to zero it.

-- 
Goldwyn
