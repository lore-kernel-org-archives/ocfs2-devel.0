Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2D80C4332F
	for <ocfs2-devel@archiver.kernel.org>; Tue, 22 Nov 2022 13:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=tCBowE1g7KRI4hPAoJwmB4CDQgfRh3T188twkU0yBm4=;
 b=z1qE9Wui/mdagPmkUzzhtSLeYmxmTrr00umNvEBkSev575fAfHYRMXXAiNWMp+OpShppv+lUU+F/
   CxWdSL+JUNfHAwK1p7oijwong6RsziL8/wCntoqhsGP40i0mCmQoSdbQbYkCCmL49z4XsRzulFLm
   mZ262RrnV4PxOwClQyHI+jvwDCMM1e1pVo0aOOo64fjufqmTe6phhvVDsE0tfrQHzZ9gLTOdd5Zr
   Ap7cNXW71cawBYJeTmfoK91AoEnT851CDEKHV9PvMSkfYserhpTqgfYa4pXql9aMIc1ZlnX1oHzQ
   3iyPjgx2r/nC6P75b0+0oewh8tP7RJ/G4rhOsw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=tCBowE1g7KRI4hPAoJwmB4CDQgfRh3T188twkU0yBm4=;
 b=L10V5Uk+WDhT7xDp2HSWbrKRPhZHe632w+BgfDsCfDzquiqxHVFYFwv7xqrLHQM/uKmczdpDeqou
   4xHQcnvdAnvhHd8yT+OeKy4foftYam4M6y24sB0pQ8pQDwQlYV1hGL2AKPjg6KFZBm+HWPZA+shx
   Fe3qEiJJ2+uP0ct3dtvzj1PoYlVOSFKJh4PkHQIZQxlvtwIsFnVPZEBA/Icw8T2U5SXUmdtb11Xu
   FAEnuV4nb2jcNm5A5pv0XPBz+kV96FnpIz5Kg4qQv8oDTBFXaHRmhv44hmtVA8tvE3N3HutbOmVL
   HWrX5InEAwlRP8jt2v2uZ4Woo+IcIf61/j8lbg==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RLR002PC5BEUBB0@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 22 Nov 2022 13:54:50 +0000 (GMT)
Message-id: <9cc55d4f-d864-aca5-78a0-ea7602c35176@linux.alibaba.com>
Date: Tue, 22 Nov 2022 21:54:31 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.2
Content-language: en-US
To: Jeff Layton <jlayton@kernel.org>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>
References: <20221120210004.381842-1-jlayton@kernel.org>
 <0c6a44ff-409e-99b2-eaa9-fd6e87a9e104@linux.alibaba.com>
 <a731e688122d1a6fdb2f7bdbd71d403fa110e9f2.camel@kernel.org>
In-reply-to: <a731e688122d1a6fdb2f7bdbd71d403fa110e9f2.camel@kernel.org>
X-Source-IP: 115.124.30.43
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10539
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 adultscore=0 mlxlogscore=999 bulkscore=0 priorityscore=191 malwarescore=0
 mlxscore=0 clxscore=13 spamscore=0 suspectscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211220103 domainage_hfrom=8622
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R131e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046049;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=16; SR=0;
 TI=SMTPD_---0VVSj4Yo_1669125271;
X-ServerName: out30-43.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: u7o9d-6t7tiG6HqU33C1jqqXvpYVgSCp
X-Proofpoint-GUID: u7o9d-6t7tiG6HqU33C1jqqXvpYVgSCp
Reporting-Meta:
 AAGFJgbmJ/P013tXcV49/AFEAbbZ/4UMuALdFn+MUL5/CqFWK9shAaBUaXEpEmKC
 tUj9KpDhyJPPS/cI+T1oHVswr25M6/Pla/VBzKqnuZC88PW1CLmgy0tb0H51MDPa
 /7RHhNtZZj/XSSVQse5Tik1kGFI2akCya+pSJqi7alcsnE5Yr2A5y+Kx1//ldTp0
 mqq9yGYrcJ5Syd0GQcjgXPg48QCLFCNDSiIzsJO5aVGvKd+3wmYqSdQysEvg5C4g
 +1vP12CISf+RL3YPx2HuMbyBPEcZnPMbdqfk2R751eE2EODm6MHK7AIqGgf/rnO0
 2weXUpITfsNg4s3fFiwQtFcpd/cSqAjcfoah8xvQ95kFCgizHas6JS7RSDydD1jq
 U0LsvKmEmEeoREsvlYp2QQEjNlzTqRqGJcm7c95T17jpNd5NoUKIfsXvyENEy2LL
 oqqY/9dOjo5oCFIN5gvy7OSbjVcrScQ1RudNm2a6VEZCwLgJnz7SXONv4YCVIrVd
 rfCxTrZAErMsQOpyvzMmWDgIKHXGXhWK+MHwn+g1qWbS



On 11/22/22 8:20 PM, Jeff Layton wrote:
> On Tue, 2022-11-22 at 09:51 +0800, Joseph Qi wrote:
>> Hi,
>>
>> On 11/21/22 4:59 AM, Jeff Layton wrote:
>>> The file locking definitions have lived in fs.h since the dawn of time,
>>> but they are only used by a small subset of the source files that
>>> include it.
>>>
>>> Move the file locking definitions to a new header file, and add the
>>> appropriate #include directives to the source files that need them. By
>>> doing this we trim down fs.h a bit and limit the amount of rebuilding
>>> that has to be done when we make changes to the file locking APIs.
>>>
>>> Signed-off-by: Jeff Layton <jlayton@kernel.org>
>>> ---
>>>  fs/9p/vfs_file.c          |   1 +
>>>  fs/afs/internal.h         |   1 +
>>>  fs/attr.c                 |   1 +
>>>  fs/ceph/locks.c           |   1 +
>>>  fs/cifs/cifsfs.c          |   1 +
>>>  fs/cifs/cifsglob.h        |   1 +
>>>  fs/cifs/cifssmb.c         |   1 +
>>>  fs/cifs/file.c            |   1 +
>>>  fs/cifs/smb2file.c        |   1 +
>>>  fs/dlm/plock.c            |   1 +
>>>  fs/fcntl.c                |   1 +
>>>  fs/file_table.c           |   1 +
>>>  fs/fuse/file.c            |   1 +
>>>  fs/gfs2/file.c            |   1 +
>>>  fs/inode.c                |   1 +
>>>  fs/ksmbd/smb2pdu.c        |   1 +
>>>  fs/ksmbd/vfs.c            |   1 +
>>>  fs/ksmbd/vfs_cache.c      |   1 +
>>>  fs/lockd/clntproc.c       |   1 +
>>>  fs/lockd/netns.h          |   1 +
>>>  fs/locks.c                |   1 +
>>>  fs/namei.c                |   1 +
>>>  fs/nfs/nfs4_fs.h          |   1 +
>>>  fs/nfs_common/grace.c     |   1 +
>>>  fs/nfsd/netns.h           |   1 +
>>>  fs/ocfs2/locks.c          |   1 +
>>>  fs/ocfs2/stack_user.c     |   1 +
>>
>> Seems it misses the related changes in:
>> fs/ocfs2/stackglue.c
>>
> 
> I was able to build ocfs2.ko just fine without any changes to
> stackglue.c. What problem do you see here?
> 
Okay, that's because there is prototype declaration in
fs/ocfs2/stackglue.h, and it seems has no real effect in current
version.

So it looks good to me. For ocfs2 part,
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
