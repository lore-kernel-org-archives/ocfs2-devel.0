Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0908C433FE
	for <ocfs2-devel@archiver.kernel.org>; Tue, 22 Nov 2022 12:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=6yNmEVxNPIjIQY2NwSu0rCsi5pTvScLcSyHkMChrwII=;
 b=E2599bwYs7v648h6+XRdO8J6FQ1tDYLiPjDe32y+PulK+8JnxuV57GAaqNiZ2BfGiyz5zAg27BSd
   yVgnH0Z1QccsUSeQYwxuygIVFitR+6+4QxoBdliAtPiyy48lisu0qiqdRrWkFaO2B6xpfqSd7BaM
   iZEM2T7z1R9dLYNb7P4pUU4dyEe0cmwJFpyzA4MC7BVj59c0/1E2FAMKfFgnWVSLhssFDOYT60sx
   U32HprHdUG9FlbX7KGbwWIH5PwYWKRR9bu366KPTwe43HPQpbGVWzq2Ia8foRJNs3MF4gtuTAlf7
   O5o8tHE+amq+pvPdodOAS9kqo+IoI5xGY4tdIQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=6yNmEVxNPIjIQY2NwSu0rCsi5pTvScLcSyHkMChrwII=;
 b=ba2Zug38dFrzXO9TaOXCMQTF3vgoV1Sjx1BZB6h6r6PRNHYMYRlKAQ+ytqrMLLqirnUJuzhHm4MK
   2jlPnpRq3gTGttnUvCnt13oLsYg5InWe8WmX+UvSB/vKiAGJilVQnj6iVYxmcPvTYUxLcbEBkyhy
   EIQIK1MxZeZDhd5StE2jDV2XMHH1UioSZeZStKva6GZaj3smpGTY9+BAdTBKfiCOTrqTCYy4zqV/
   qfQsaYe4MZTSOJKFrXHj8XHrg7mOu7BPwuIS+HpxsQHxYD69xiATYnI/ZgU9N32rl7AU7LVp7wV6
   TARNiULq6m4BrabXxeMk81mcATbCQmUWBfwTSg==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RLR005N70YW4Q50@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 22 Nov 2022 12:20:56 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org; s=k20201202;
 t=1669119638; bh=omBfWXmMhLMm+WJGcOqaotuYzo99NcFtkFUjLGTxJkU=;
 h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
 b=lCqeNISkHr5FV5oUA/uF7cCqbH3pbaJZzL0H/JeQImnqkxBP/qna4Vwgxuxwwf4kc
 djCzx51ajPQzJsx7t6fcFaQ3CPrg1HyiCa0H584zbvwYZVAhxyYK9KeJP/cZSm7jN0
 AEQFZIjKudut9Bn5O9uHSqMDAio5e4wG5sa2i3DoX7eTRf+obcb5zEzndUU3Fwo275
 rIYFdUuTfDxxMV446wuHU7u2FLiPhi/QMUcdaTapUWa++/h/6C38Q3lKoDzCYdb8Qd
 YelQN+YEM82ey5KUKNOPaXvgHVIDzs2zei/oxdiPIwrOhlWjLs2M+5ia9+Ld6VGXMR
 y+AjrCDtny9iA==
Message-id: <a731e688122d1a6fdb2f7bdbd71d403fa110e9f2.camel@kernel.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>
Date: Tue, 22 Nov 2022 07:20:35 -0500
In-reply-to: <0c6a44ff-409e-99b2-eaa9-fd6e87a9e104@linux.alibaba.com>
References: <20221120210004.381842-1-jlayton@kernel.org>
 <0c6a44ff-409e-99b2-eaa9-fd6e87a9e104@linux.alibaba.com>
User-Agent: Evolution 3.46.1 (3.46.1-1.fc37)
MIME-version: 1.0
X-Source-IP: 145.40.68.75
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10538
 signatures=596816
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
From: Jeff Layton via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Jeff Layton <jlayton@kernel.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: ams.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.kernel.org ~all
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-GUID: 5dGH3DWmMC90cECpIAlZ565RMMqioti9
X-Proofpoint-ORIG-GUID: 5dGH3DWmMC90cECpIAlZ565RMMqioti9
Reporting-Meta:
 AAHxVoikfbRHaCfCAZhliKrBYASK5TX3y8tSh5/+aL87VjqI20NVMQv5CExnxYXf
 ART07FgATgse9HvvvPmOZixjcSmXTUY25uEl4hy37n4OCUdx3ZNfBuzFnLz9FkEP
 BFU+KfQzEN6qhqeOFBZNyAWtGfwhVWNewP+qlKcIEcDFUBMdhMFkrJP8IAC6nCOc
 d+MVPqm9DZmLIdT6QU6baf+FFAN38irlyDRgOTVeapRUXZKKGWbOA6KG2eZMu3O6
 OBMalzqAeyauTeyqz9sy0k5tYQplXNt5ttOSm94XB/0OI+dbCeaMUlwPTx3Fu5as
 NRbxMx8CaBBUVsFwnGEOhh8WvZXU1B9dy3Tz6ntFZ3yMbdjLwBgb8mVUWIACLgHb
 oec1//lf8aSN/nNq3fXijHCP17GVRwSuWKxB2vIFTQBaFP9TucFs4+tnUpzNmuVu
 yN+p51leXtBfBWotFzvcZW43Qd4ziwIv5yfSCddjB/c8QcU1uP3NZal+ctb8z6BH
 6qXqqOHCp0NYY5ffoC7EJEPLc7/hiw17i0SvJmS99x8=

On Tue, 2022-11-22 at 09:51 +0800, Joseph Qi wrote:
> Hi,
> 
> On 11/21/22 4:59 AM, Jeff Layton wrote:
> > The file locking definitions have lived in fs.h since the dawn of time,
> > but they are only used by a small subset of the source files that
> > include it.
> > 
> > Move the file locking definitions to a new header file, and add the
> > appropriate #include directives to the source files that need them. By
> > doing this we trim down fs.h a bit and limit the amount of rebuilding
> > that has to be done when we make changes to the file locking APIs.
> > 
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/9p/vfs_file.c          |   1 +
> >  fs/afs/internal.h         |   1 +
> >  fs/attr.c                 |   1 +
> >  fs/ceph/locks.c           |   1 +
> >  fs/cifs/cifsfs.c          |   1 +
> >  fs/cifs/cifsglob.h        |   1 +
> >  fs/cifs/cifssmb.c         |   1 +
> >  fs/cifs/file.c            |   1 +
> >  fs/cifs/smb2file.c        |   1 +
> >  fs/dlm/plock.c            |   1 +
> >  fs/fcntl.c                |   1 +
> >  fs/file_table.c           |   1 +
> >  fs/fuse/file.c            |   1 +
> >  fs/gfs2/file.c            |   1 +
> >  fs/inode.c                |   1 +
> >  fs/ksmbd/smb2pdu.c        |   1 +
> >  fs/ksmbd/vfs.c            |   1 +
> >  fs/ksmbd/vfs_cache.c      |   1 +
> >  fs/lockd/clntproc.c       |   1 +
> >  fs/lockd/netns.h          |   1 +
> >  fs/locks.c                |   1 +
> >  fs/namei.c                |   1 +
> >  fs/nfs/nfs4_fs.h          |   1 +
> >  fs/nfs_common/grace.c     |   1 +
> >  fs/nfsd/netns.h           |   1 +
> >  fs/ocfs2/locks.c          |   1 +
> >  fs/ocfs2/stack_user.c     |   1 +
> 
> Seems it misses the related changes in:
> fs/ocfs2/stackglue.c
> 

I was able to build ocfs2.ko just fine without any changes to
stackglue.c. What problem do you see here?

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
