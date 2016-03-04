From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Fri, 4 Mar 2016 11:08:50 +0800
Subject: [Ocfs2-devel] [QUESTION] How to recover a deleted file?
In-Reply-To: <D1E4D02760513D4B90DC3B40FF32AF355EE21FC1@H3CMLB14-EX.srv.huawei-3com.com>
References: <D1E4D02760513D4B90DC3B40FF32AF355EE21FC1@H3CMLB14-EX.srv.huawei-3com.com>
Message-ID: <56D8FC42.5030309@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 03/04/2016 08:47 AM, Shichangkuo wrote:
> Hi All,
> 
>     I have removed a file which was very important to me by mistake.
> Does someone once encounta problem like this, and could the file be
> undeleted?
Maybe you can rebuild it manually if released clusters are not reused.
Umount the volume first, then use logdump of debugfs.ocfs2 to find the
latest extents tree of the file before it is removed. With this, you can
copy the removed file out. Good luck.

Thanks,
Junxiao.

> 
>  
> 
> Many thanks.
> 
> Changkuo.Shi
> 
> -------------------------------------------------------------------------------------------------------------------------------------
> ????????????????????????????????????
> ????
> ???????????????????????????????????
> ?????
> ????????????????????????????????????
> ????
> ???
> This e-mail and its attachments contain confidential information from
> H3C, which is
> intended only for the person or entity whose address is listed above.
> Any use of the
> information contained herein in any way (including, but not limited to,
> total or partial
> disclosure, reproduction, or dissemination) by persons other than the
> intended
> recipient(s) is prohibited. If you receive this e-mail in error, please
> notify the sender
> by phone or email immediately and delete it!
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
