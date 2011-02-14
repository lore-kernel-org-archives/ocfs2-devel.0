From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Mon, 14 Feb 2011 12:24:01 -0600
Subject: [Ocfs2-devel] [PATCH] Zero from EOF instead of next block
In-Reply-To: <20110214072503.GA8413@noexit>
References: <AANLkTik_4d7Ey5LCcV7pQMXEeZ_GcN-gC6cK-oX7f+B9@mail.gmail.com>
	<20110214072503.GA8413@noexit>
Message-ID: <AANLkTikTP7wtSGsoUSw1pVT6aWDrjSYFrn_A+8Aam9HD@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Feb 14, 2011 at 1:25 AM, Joel Becker <jlbec@evilplan.org> wrote:
> On Mon, Feb 14, 2011 at 12:21:41AM -0600, Goldwyn Rodrigues wrote:
>> ocfs2_zero_extend() extends the file from the next page offset
>> rather from the current file size. zero_extend_page() should
>> call ocfs2_zero_partial_cluster() to set zero rest of the cluster
>> when the file size is within the page boundaries.
>
> ? ? ? ?We just went over this. ?It is intentional that we start from
> the next block. ?Linux code always assumes that the block containing
> i_size is properly zeroed to its end. ?Our last set of fixes for this
> made sure we were doing that correctly. ?Or so I thought.
> ? ? ? ?Your patch description looks like you are worried that we don't
> zero from EOF to End-Of-Block. ?Have you proof we've failed that again?
> Or are you worried that we don't zero from EOB to End-Of-Cluster? ?We
> used to zero to EOC, but we now know that to be a mistake.
>

Why is zeroing to EOC a mistake?

I ran my tests again and found the problem to be from EOB to
End-of-cluster, and of course this happens only with
blocksize<clustersize. So, in ocfs2_zero_extend rewriting zero_to_size
to end-of-cluster works correctly  -

zero_to_size = ocfs2_align_bytes_to_clusters(sb, zero_to_size);

The test case is attached. Modify run_ocfs2_sparse_writing_test.sh accordingly.

-- 
Goldwyn
-------------- next part --------------
A non-text attachment was scrubbed...
Name: ocfs2_sparse_writing_test_kit.tbz
Type: application/x-bzip-compressed-tar
Size: 2558 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20110214/0b0c8fb7/attachment.bin 
