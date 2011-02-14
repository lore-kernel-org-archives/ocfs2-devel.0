From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Mon, 14 Feb 2011 16:16:37 -0600
Subject: [Ocfs2-devel] [PATCH] Zero from EOF instead of next block
In-Reply-To: <20110214220021.GB8413@noexit>
References: <AANLkTik_4d7Ey5LCcV7pQMXEeZ_GcN-gC6cK-oX7f+B9@mail.gmail.com>
	<20110214072503.GA8413@noexit>
	<AANLkTikTP7wtSGsoUSw1pVT6aWDrjSYFrn_A+8Aam9HD@mail.gmail.com>
	<20110214220021.GB8413@noexit>
Message-ID: <AANLkTikPdMgJWexFbBx8fRKxwAoKGsbiYkHR49Kfk90=@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Feb 14, 2011 at 4:00 PM, Joel Becker <jlbec@evilplan.org> wrote:
> On Mon, Feb 14, 2011 at 12:24:01PM -0600, Goldwyn Rodrigues wrote:
>> On Mon, Feb 14, 2011 at 1:25 AM, Joel Becker <jlbec@evilplan.org> wrote:
>> Why is zeroing to EOC a mistake?
>
> ? ? ? ?Because Linux writeback trims all writes to EOB for the block
> surrounding i_size. ?So when you fill pages to EOC, and blocksize !=
> clustersize, you end up with pages that are never flushed to disk.
> This becomes a problem. ?In reflink CoW, it ends up being a BUG().
> ? ? ? ?See
> http://kerneltrap.org/mailarchive/linux-kernel/2010/6/28/4587750 for the
> entire discussion. ?The final fix patches ended going in as:
>
> a4bfb4c ocfs2: When zero extending, do it by page.
> 5693486 ocfs2: Zero the tail cluster when extending past i_size.
> 693c241 ocfs2: No need to zero pages past i_size.
>
>> I ran my tests again and found the problem to be from EOB to
>> End-of-cluster, and of course this happens only with
>> blocksize<clustersize. So, in ocfs2_zero_extend rewriting zero_to_size
>> to end-of-cluster works correctly ?-
>
> ? ? ? ?I'm going to check out your test case, but please explain what
> you think is broken.
>

Oh, I thought the test case was self-explanatory. The test case first writes
a lot of dirty data on disk "0xbaadfeed", syncs the data and removes
the file so that the filesystem has a lot of "0xbaadfeed" data on it.

The second executable writes records of 32 bytes and seeks another 32
bytes. While reading the file back, 0xbaadfeed is read when zeros are
expected. The program shows where the unexpected data is found.

So, for holes not spanning extents or even blocks, the data which was
on disk previously shows up.

Let me know if you need further explanation.

-- 
Goldwyn
