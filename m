From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 19 Feb 2009 11:29:17 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: anti stale inode for nfs (V3)
In-Reply-To: <499D5A42.90702@oracle.com>
References: <200902171255.n1HCsxeo017544@acsinet13.oracle.com>	<20090218013700.GA26431@mail.oracle.com>
	<499D5A42.90702@oracle.com>
Message-ID: <499DB30D.9070005@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Finish the kernel bits first. Once that is checked in, the following
files in the tools will need to be updated.
=> libocfs2/lockid.c
=> include/ocfs2-kernel/ocfs2_lockid.h (copy from kernel)

Wengang Wang wrote:
>> It will need to be added to debugfs.ocfs2's lock displays.
>>     
> what's this in detail?
> the display for "debugfs.ocfs2 -d <lockres>"? such as the rename lock
>
> [root at ocfs2-2 ~]# debugfs.ocfs2 -d R000000000000000000000000000000
> Lockres:    R000000000000000000000000000000
> Type:       Rename
> Block:      0
> Generation: 0x00000000
>
> ?
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>   
