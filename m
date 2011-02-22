From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Tue, 22 Feb 2011 16:09:47 -0600
Subject: [Ocfs2-devel] [PATCH] Treat writes as new when holes span
 across page boundaries
In-Reply-To: <20110222215428.GB28774@noexit>
References: <AANLkTi=pEu5y4=kjG1YoLR+YCd7Ak21QaFQz=AR3dffX@mail.gmail.com>
	<20110220070953.GC17784@noexit>
	<AANLkTinuhh9nF=6NQbe81NbE0K95huVtdDdC9Gb2pU=5@mail.gmail.com>
	<20110221020856.GL17784@noexit>
	<AANLkTimXr0rA5FV_ep-y9uetUVcD3w+9MuTZeBnLXDvG@mail.gmail.com>
	<20110222083648.GC30966@noexit>
	<AANLkTi=+vK_17n-ENMznWbYKBZcZ0v1U0ptgv8qThkUv@mail.gmail.com>
	<20110222213927.GA28774@noexit> <20110222215428.GB28774@noexit>
Message-ID: <AANLkTikByGbpDyDmbM7kNV-ZAt1Ts5BzbM0Ospi=o8Ki@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Feb 22, 2011 at 3:54 PM, Joel Becker <jlbec@evilplan.org> wrote:
> On Tue, Feb 22, 2011 at 01:39:28PM -0800, Joel Becker wrote:
>> On Tue, Feb 22, 2011 at 01:02:13PM -0600, Goldwyn Rodrigues wrote:
>> > On Tue, Feb 22, 2011 at 2:36 AM, Joel Becker <jlbec@evilplan.org> wrote:
>> > > ? ? ? ?Please try the attached patch and see if it fixes the problem.
>> > > It should work on its own, without your changes. ?If I have it wrong,
>> > > we'll continue to evaluate the problem. ?I'd test it myself, but my VM
>> > > setup is currently broken.
>> > >
>> >
>> > It does not work. However, it shows the behavior similar to "nosparse"
>> > without patch. So, I would say what you are targeting is achieved but
>> > another problem resurfaces. This is because nothing zeros pages beyond
>> > i_size in ocfs2_map_page_blocks(), since we return early because of -
>> >
>> > ? ? ? ? if (ret == 0 || !new)
>> > ? ? ? ? ? ? ? ? return ret;
>>
>> ? ? ? Returning here is correct, because ret should == 0. ?The new
>> part is about zeroing in the case of error. ?We should obviously handle
>> it better before we get to this line.
>> ? ? ? I like that we come in line nosparse and sparse. ?What does
>> tailtest do for you? ?Does it fail or succeed?
>
> ? ? ? ?Looking some more. ?ocfs2_zero_tail() is supposed to handle
> this, isn't it? ?ocfs2_write_begin_nolock() calls ocfs2_zero_tail(pos),
> which calls ocfs2_zero_extend(pos), which works up to
> ocfs2_clusters_for_bytes(pos). ?Doesn't this include your cluster?
> Shouldn't the page already be loaded into the pagecache with zeros?
>
>

Din't you discard that idea in my previous attempt? ;)

On a serious note, no it doesn't because zero_start and zero_to_size
are the same when pos is on a block boundary and hence the loop does
not execute.


-- 
Goldwyn
