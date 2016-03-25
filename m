From: Darrick J. Wong <darrick.wong@oracle.com>
Date: Thu, 24 Mar 2016 23:49:45 -0700
Subject: [Ocfs2-devel] The comment should be started with 0x08.
In-Reply-To: <71604351584F6A4EBAE558C676F37CA48294663E@H3CMLB14-EX.srv.huawei-3com.com>
References: <71604351584F6A4EBAE558C676F37CA48294663E@H3CMLB14-EX.srv.huawei-3com.com>
Message-ID: <20160325064945.GC5812@birch.djwong.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Mar 25, 2016 at 02:02:36AM +0000, Guozhonghua wrote:
> 
> struct ocfs2_extended_slot {
> /*00*/  __u8    es_valid;
>         __u8    es_reserved1[3];
>         __le32  es_node_num;
> -/*10*/
> +/*08*/
> };
> 
> 
> -------------------------------------------------------------------------------------------------------------------------------------
> ????????????????????????????????????????
> ????????????????????????????????????????
> ????????????????????????????????????????
> ???
> This e-mail and its attachments contain confidential information from H3C, which is

No signed-off-by and the message is confidential information too!

See section 11 of SubmittingPatches[1] and try again please.

--D

[1] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/SubmittingPatches

> intended only for the person or entity whose address is listed above. Any use of the
> information contained herein in any way (including, but not limited to, total or partial
> disclosure, reproduction, or dissemination) by persons other than the intended
> recipient(s) is prohibited. If you receive this e-mail in error, please notify the sender
> by phone or email immediately and delete it!
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
