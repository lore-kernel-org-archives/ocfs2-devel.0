Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98967C4332F
	for <ocfs2-devel@archiver.kernel.org>; Tue, 22 Nov 2022 01:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=+5HiDT1pwBv34j9bYnecu+umaGdPGGAeXJ1jalfm9y8=;
 b=MxHNV1UbhL+KA6pJU88McbkvkndjNzDO/UkrYD+6FLUg6FXY2+SZcbLC7fp+cAfIaZQgigVkUl/T
   3cdjV9npl36TW0xIw4+0Ng+VFdDUVrKTfFyZuPAeG5twZt68L4+9kkIVwky+zmQY0IRsp/cMaYAg
   RfMjlqZqJ5A26yiD0hUXJUpUu47w7LTWQsuMMFp9Rr1coKt6YRguaN/H9tTS7X2/Co1ar7S+oiDe
   3s/989k+LBkFIv1qZHwnH94wFXbfv1lG6E4ULeiyAqjce+zbnRErO1VdeVcf79RjVguvQYc3oXNE
   writ5pH9BJ9AHCQSBTrAz/YOpS4nYuaU5SgVDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=+5HiDT1pwBv34j9bYnecu+umaGdPGGAeXJ1jalfm9y8=;
 b=hKN4BFvKM1dwVhQVgi9MSUtzBfR+5Lp7Kp4XJbe6WBpwOu10miQi763Yim4cuSJ7LffLUkqpxNTC
   HLzhZsjSzeyA+UoHNdXJupXbygg4ToJvdLrUhWkki+d8ixKQ6q9P+IfOH5FbYqdQQF7LD+tBOf0J
   TCYSmRotkkRGRdP0WV5fH6p/kCo/tTc0wN02YE9AnRIp18+CVHnWfrLpanji5sDujjinv3vylrpL
   5xYHc+WOIuzrQeY0zVWFlFJvHNsAyk9UVZCo1724leCOST8D6QYkhG+loGVrwcSm7VH/YNXI+9ew
   PCwFvzy71CBxl1Sie4EbxVNuHu1pBP8U/wydAQ==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RLQ009NP7UJ8QD0@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 22 Nov 2022 01:51:55 +0000 (GMT)
Message-id: <0c6a44ff-409e-99b2-eaa9-fd6e87a9e104@linux.alibaba.com>
Date: Tue, 22 Nov 2022 09:51:35 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.2
Content-language: en-US
To: Jeff Layton <jlayton@kernel.org>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>
References: <20221120210004.381842-1-jlayton@kernel.org>
In-reply-to: <20221120210004.381842-1-jlayton@kernel.org>
X-Source-IP: 115.124.30.45
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10538
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
 suspectscore=0 mlxlogscore=939 clxscore=84 adultscore=0 lowpriorityscore=0
 phishscore=0 mlxscore=0 bulkscore=0 malwarescore=0 impostorscore=0
 priorityscore=60 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211220011 domainage_hfrom=8622
Cc: linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
 samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
 cluster-devel@redhat.com, devel@lists.orangefs.org,
 linux-fsdevel@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
 ceph-devel@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-afs@lists.infradead.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH] filelock: move file locking definitions to
 separate header file
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.15
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/options/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel/>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
From: Joseph Qi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Joseph Qi <joseph.qi@linux.alibaba.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R211e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018045192;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=16; SR=0;
 TI=SMTPD_---0VVPgoyJ_1669081895;
X-ServerName: out30-45.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: eUVEH5oolBGeOff1z8U_PlWqeBuZHEN5
X-Proofpoint-ORIG-GUID: eUVEH5oolBGeOff1z8U_PlWqeBuZHEN5
Reporting-Meta:
 AAHadbcXiforXsiu0DFjvPkkbI8VRWz4EOXC6XbGTsnIgJjuYh83TKQpwM5GoWz3
 vEG42OSxqAfOrfuxXq+HMHOFWxGXL8BHh581b40iW2PBsVFZK1ZhFzLItKXoyyJs
 syV4cPcfTRpu2TRqNa15HW7Bi5LOSRabKOcvWwmVhHVcLaQLGgfv8v41dRRQSVHG
 S5cjt7zmMJBriIrk6vyFr/XPEOiz+lZYylDGM+8n/vJBJqTTC2Tozkjrxk7jZeGn
 vJ1oidJ7L9Bz6o0Nu4ugJkF1cUYTkvB99xeqvr8RfI47gSmopYBMUplRVFP7GA5C
 t3k8HvmjHD6O3WwqEk7BEwd1AXxa7ssrmrh7j0/jwghrTDocDoFK4gCf2lqJv+LC
 a7yhOhhuXYwWoXo+1/d/RqhcruyMJ2tkT5ps1C6KOOfmsZEyAyQ+N+4jm7eAe10X
 clbpbaIUKqgLYdtdkyKZ4WGcpBjQCy+PO0EreQ6aj2ZraMZYYAz+5far5lRjseA8
 zceaQ4Hh1JOuib18uJECktGa3mT4nCedH2SNqR/oYf9P6Q==

Hi,

On 11/21/22 4:59 AM, Jeff Layton wrote:
> The file locking definitions have lived in fs.h since the dawn of time,
> but they are only used by a small subset of the source files that
> include it.
> 
> Move the file locking definitions to a new header file, and add the
> appropriate #include directives to the source files that need them. By
> doing this we trim down fs.h a bit and limit the amount of rebuilding
> that has to be done when we make changes to the file locking APIs.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/9p/vfs_file.c          |   1 +
>  fs/afs/internal.h         |   1 +
>  fs/attr.c                 |   1 +
>  fs/ceph/locks.c           |   1 +
>  fs/cifs/cifsfs.c          |   1 +
>  fs/cifs/cifsglob.h        |   1 +
>  fs/cifs/cifssmb.c         |   1 +
>  fs/cifs/file.c            |   1 +
>  fs/cifs/smb2file.c        |   1 +
>  fs/dlm/plock.c            |   1 +
>  fs/fcntl.c                |   1 +
>  fs/file_table.c           |   1 +
>  fs/fuse/file.c            |   1 +
>  fs/gfs2/file.c            |   1 +
>  fs/inode.c                |   1 +
>  fs/ksmbd/smb2pdu.c        |   1 +
>  fs/ksmbd/vfs.c            |   1 +
>  fs/ksmbd/vfs_cache.c      |   1 +
>  fs/lockd/clntproc.c       |   1 +
>  fs/lockd/netns.h          |   1 +
>  fs/locks.c                |   1 +
>  fs/namei.c                |   1 +
>  fs/nfs/nfs4_fs.h          |   1 +
>  fs/nfs_common/grace.c     |   1 +
>  fs/nfsd/netns.h           |   1 +
>  fs/ocfs2/locks.c          |   1 +
>  fs/ocfs2/stack_user.c     |   1 +

Seems it misses the related changes in:
fs/ocfs2/stackglue.c

Thanks,
Joseph

>  fs/open.c                 |   1 +
>  fs/orangefs/file.c        |   1 +
>  fs/proc/fd.c              |   1 +
>  fs/utimes.c               |   1 +
>  fs/xattr.c                |   1 +
>  fs/xfs/xfs_buf.h          |   1 +
>  fs/xfs/xfs_file.c         |   1 +
>  fs/xfs/xfs_inode.c        |   1 +
>  include/linux/filelock.h  | 428 ++++++++++++++++++++++++++++++++++++++
>  include/linux/fs.h        | 421 -------------------------------------
>  include/linux/lockd/xdr.h |   1 +
>  38 files changed, 464 insertions(+), 421 deletions(-)
>  create mode 100644 include/linux/filelock.h
> 
> Unless anyone has objections, I'll plan to merge this in via the file
> locking tree for v6.3. I'd appreciate Acked-bys or Reviewed-bys from
> maintainers, however.
> 

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
