From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Tue, 22 Feb 2011 13:02:13 -0600
Subject: [Ocfs2-devel] [PATCH] Treat writes as new when holes span
	across page boundaries
In-Reply-To: <20110222083648.GC30966@noexit>
References: <AANLkTi=pEu5y4=kjG1YoLR+YCd7Ak21QaFQz=AR3dffX@mail.gmail.com>
	<20110220070953.GC17784@noexit>
	<AANLkTinuhh9nF=6NQbe81NbE0K95huVtdDdC9Gb2pU=5@mail.gmail.com>
	<20110221020856.GL17784@noexit>
	<AANLkTimXr0rA5FV_ep-y9uetUVcD3w+9MuTZeBnLXDvG@mail.gmail.com>
	<20110222083648.GC30966@noexit>
Message-ID: <AANLkTi=+vK_17n-ENMznWbYKBZcZ0v1U0ptgv8qThkUv@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joel,

On Tue, Feb 22, 2011 at 2:36 AM, Joel Becker <jlbec@evilplan.org> wrote:
> On Sun, Feb 20, 2011 at 11:44:05PM -0600, Goldwyn Rodrigues wrote:
>> >> > ? ? ? ?Secondly, ocfs2_should_read_blk() already checks for blocks past
>> >> > i_size and skips reading them. ?So if you are trying to avoid reading
>> >> > them, it is already handled.
>> >>
>
>> Sorry, I was wrong in my previous explanation on why
>> ocfs2_should_read_blk returns 1. ocfs2_should_read_blk returns 1
>> because of ocfs2_sparse_alloc() and hence forces the garbage read.
>
> ? ? ? ?You're right, that's why ocfs2_should_read_block() returns 1.
> But why would it ever want to read blocks that are outside i_size?
> We've guaranteed that they won't be initialized...
> ? ? ? ?I wonder if that's the bug? ?We originally used to zero to EOC.
> For sparse files, that could never be any clusters past i_size. ?With
> the fix I put in for writepage, we no longer zero the blocks past
> i_size. ?I think the sparse check there is no longer accurate.
> ? ? ? ?Please try the attached patch and see if it fixes the problem.
> It should work on its own, without your changes. ?If I have it wrong,
> we'll continue to evaluate the problem. ?I'd test it myself, but my VM
> setup is currently broken.
>

It does not work. However, it shows the behavior similar to "nosparse"
without patch. So, I would say what you are targeting is achieved but
another problem resurfaces. This is because nothing zeros pages beyond
i_size in ocfs2_map_page_blocks(), since we return early because of -

        if (ret == 0 || !new)
                return ret;


>> On a different note, what I have not been able to explain as yet is,
>> when the file is created on a nosparse filesystem, the holes have junk
>> (not 0xbaadfeed, ie what was written previously but junk). Could you
>> think of a reason why? In any case, this patch resolves this issue.
>
> ? ? ? ?Do they have junk without your patch, or just with your patch?
>

Without my patch, there is junk in the holes. With my patch holes are zeros.
Understood why it happens, explained before..

-- 
Goldwyn
