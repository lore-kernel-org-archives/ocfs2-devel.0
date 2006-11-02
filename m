From: Sunil Mushran <Sunil.Mushran@oracle.com>
Date: Thu Nov  2 17:06:20 2006
Subject: [Ocfs2-devel] Re: [Ocfs2-tools-devel] Patch for debugfs.ocfs2
	``icheck'' command
In-Reply-To: <200611021638.36134.jie.gong@oracle.com>
References: <200611021547.47381.jie.gong@oracle.com>
	<200611021638.36134.jie.gong@oracle.com>
Message-ID: <454A9609.8060402@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

http://oss.oracle.com/~smushran/debugfs.ocfs2-icheck-04a.patch

The comments have been inlined in the patch.

Summary;
1. Follow Tao's recommendation for checking against known holes.
The check for the first cluster group can be done before hand, and for
the remaining, it can be done as part of the group descriptor check.

2. It should allow users to provide multiple block numbers. See do_locate()
for more.

3. The output should not only accommodate multiple block#s but also
provide a little more information. For e.g., for a regular file, list the
logical block#. (The idea behind this is for users to be able to easily
map a physical block on a device to an offset in a file.) Other inode types
are easy to search thru and may not need any help. A known hole
should be marked as a HOLE. We'll clean it up later.

Other than that, it is looking good.

Sunil

GONG Jie wrote:
> Sorry for miss the file find_block_inode.h.
>
> On Thursday 02 November 2006 15:47, GONG Jie wrote:
>   
>> Hi, all
>>
>> Enclosed please find the rewrite debugfs.ocfs2 ``icheck'' patch for your
>> review.
>>     
>
>   
> ------------------------------------------------------------------------
>
> _______________________________________________
> Ocfs2-tools-devel mailing list
> Ocfs2-tools-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-tools-devel
>   
