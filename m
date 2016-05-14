From: Jeong Woo Seo <seo@xsinc.co.kr>
Date: Sun, 15 May 2016 01:56:05 +0900 (KST)
Subject: [Ocfs2-devel]
 =?utf-8?q?ocfs2=3A_fix_recursive_locking_deadlock?=
In-Reply-To: <1462856023-13801-1-git-send-email-junxiao.bi@oracle.com>
References: <1462856023-13801-1-git-send-email-junxiao.bi@oracle.com>
Message-ID: <a6332c53a5705972d35d5ff73afdefcf@cweb17.nm.nhnsystem.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

  I applied patch and when try to trim ocfs2 volume, it turns to read-only status.
 
log is :
 
[114572.044443] OCFS2: ERROR (device drbd0): ocfs2_validate_gd_self: Group descriptor #8257536 has bad signature
[114572.044501] On-disk corruption discovered. Please run fsck.ocfs2 once the filesystem is unmounted.
[114572.044528] OCFS2: File system is now read-only.
[114572.044544] (fstrim,9432,1):ocfs2_trim_fs:7399 ERROR: status = -30

  


 ??? ???? XS INC. ? ? ?  ? ? ?  / ? ? ?/ Seo Jeong Woo
??? ??? ??3? 197-5 ??IT?? 1004?
Mobile 010-3896-9002 / Office 02-2088-3243
 FAX  02-2039-3076 / E-mail seo at xsinc.co.kr 
  
-----Original Message-----
From: "Junxiao Bi"&lt;junxiao.bi at oracle.com&gt; 
To: &lt;ocfs2-devel at oss.oracle.com&gt;; &lt;akpm at linux-foundation.org&gt;; 
Cc: &lt;mfasheh at suse.com&gt;; 
Sent: 2016-05-10 (?) 13:53:41
Subject: [Ocfs2-devel] ocfs2: fix recursive locking deadlock
 

Hi,

These two patches is to fix recursive locking deadlock issues. As we
talked with Mark before, recursive locking is not allowed in ocfs2,
so these two patches fixes the deadlock issue with reverting back
patches to avoid recursive locking. Please review.

Thanks,
Junxiao.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel at oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20160515/2f869ef2/attachment.html 
