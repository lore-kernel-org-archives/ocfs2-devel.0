Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47E14C46467
	for <ocfs2-devel@archiver.kernel.org>; Wed, 11 Jan 2023 17:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=CW63yG+4IjZjtp+Xb5sHsokg3nfp8LtCyoqCY+XOhP0=;
 b=GmWA2dDUDVHZnbb+nEZh3aH02OVth7yr+2bW6lNio+UsBQbut5knRXUo5MA2Y8GbY2W82DdJsxo2
   YlVSkA2MZr4U3sclEEpm8kyqITgQw3em9drRK+T1jMvmRAVVayVN0EZSFt7lOmObU5387RnxgjU/
   uIckV+1jaAVuPozQUyjEUY80SOB6+yNa5Aefksn3TXhw/Jx5ELh043qx4uEMaZ/MEpCqt72+ut5H
   vP4OByQUCzmQumn8sktm5I27fKr9/JNoQsOtwhQN71UeMhJSQdInsvVFoogKIKg+rptERXvo993l
   zC5gFq5vEh8C32BHvU4H4h7EhdC2/yB9Qyrkxg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=CW63yG+4IjZjtp+Xb5sHsokg3nfp8LtCyoqCY+XOhP0=;
 b=hHwNqhrxsy8QYLP2xPxOADm94UH9dwlZ3bvOwmTSr626EKYQHdFW0Vjv+KqZWu8xqQddnnlW9ntl
   2WnL6sfg/JS2cfXSeKhpTMOzUQ1qtlKmakaCtRndPAMChCjIf411l+WR5heuFiI0MRuPdFwiXQPw
   6L9Jzjt4IRxbDZtWzgQe0VE6lqjCkBoqtYL0QxpsgQBg9nvJXPwi/cqKAMCFQOt71Xb4/n4gWRiF
   rOu+SUKVVHK8dhWQn2Ew9EMyt1oknnxvjm/Ku9eT6zmH6OEGwaOe0kTgnbhGgsTYqnGdKqiFwLDN
   adXvIbDW31ysT5EpRVGxafIu77SMmEsOCmCPLw==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0ROC00BSM0BSUJD0@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 11 Jan 2023 17:23:52 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org; s=k20201202;
 t=1673431768; bh=vTG8tkGkgzpoXSI2/xLzI6Hvg87vZDKZ00P9yxoHI64=;
 h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
 b=KgIY9bOYwJCyOfCiW7o6nNIrn2iWWQQ5tXwTIwDD6HKYH/4GbiuaYsi5USHAueqfF
 qW+c9QphwXJnJEBBSkeZ3QzZ2qjL78DX6brtpjE96UlFGKckD3CshL11vT4uRRIWHz
 uUGbPHoGrJNEMH9NM6lzSSC+MCcnGvoWlKzsj1YG1ecUDwUwqKkPrgm4FQQGLXhuZ6
 tP2riGZnuacry7vNSFPRIhTvYGOxr/NRJY22iA4K0Dv3RFfUbw19rHig2ttj+ZUO0x
 2LDUVW+peqK8CV6IqOT/qJhTun4pq3CFSD/d/wg4wfgC4RYw29uJqQkwH1RoioVK2c
 R6J71KCrpkAKg==
Message-id: <b93df374c14a0841823da7d5fadd96a0077762c6.camel@kernel.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Date: Wed, 11 Jan 2023 05:09:22 -0500
In-reply-to: <Y74bDlSiEb2dRFSx@ZenIV>
References: <20230105211937.1572384-1-jlayton@kernel.org>
 <Y74bDlSiEb2dRFSx@ZenIV>
User-Agent: Evolution 3.46.2 (3.46.2-1.fc37)
MIME-version: 1.0
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10586
 signatures=596816
Cc: Latchesar Ionkov <lucho@ionkov.net>,
 Martin Brandenburg <martin@omnibond.com>,
 Dominique Martinet <asmadeus@codewreck.org>,
 Christian Schoenebeck <linux_oss@crudebyte.com>,
 David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>,
 linux-xfs@vger.kernel.org, Mike Marshall <hubcap@omnibond.com>,
 linux-cifs@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>,
 Miklos Szeredi <miklos@szeredi.hu>, Russell King <linux@armlinux.org.uk>,
 linux-afs@lists.infradead.org, cluster-devel@redhat.com,
 Christine Caulfield <ccaulfie@redhat.com>,
 v9fs-developer@lists.sourceforge.net, Ilya Dryomov <idryomov@gmail.com>,
 Namjae Jeon <linkinjeon@kernel.org>, devel@lists.orangefs.org,
 Shyam Prasad N <sprasad@microsoft.com>,
 Eric Van Hensbergen <ericvh@gmail.com>, linux-nfs@vger.kernel.org,
 Tom Talpey <tom@talpey.com>, linux-fsdevel@vger.kernel.org,
 ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>,
 Trond Myklebust <trond.myklebust@hammerspace.com>,
 linux-arm-kernel@lists.infradead.org, Christian Brauner <brauner@kernel.org>,
 Paulo Alcantara <pc@cjr.nz>, samba-technical@lists.samba.org,
 linux-kernel@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
 Steve French <sfrench@samba.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Chuck Lever <chuck.lever@oracle.com>, ocfs2-devel@oss.oracle.com,
 Anna Schumaker <anna@kernel.org>, Bob Peterson <rpeterso@redhat.com>,
 Steve French <stfrench@microsoft.com>
Subject: Re: [Ocfs2-devel] [PATCH v2] filelock: move file locking definitions
 to separate header file
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
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.kernel.org ~all
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-ORIG-GUID: d-RqZ4BlCUDJnFKyFXfJGv7oATIKbKRU
X-Proofpoint-GUID: d-RqZ4BlCUDJnFKyFXfJGv7oATIKbKRU
X-Mailman-Approved-At: Wed, 11 Jan 2023 17:23:49 +0000
Reporting-Meta:
 AAEsf/JyPiaHwETmdK4+8xEm5lrkveHQ3G8FPwiw4qKQT/aXKR1z/C25hPXK0/BV
 7pw/8b56MZhHBVSWI9m1hoDfN3b4yYAOv4Bgk17lnkZVDiws8OJKy/NIHk3f0dMX
 lEM7TfRBpR4tNHkPI0ukdt9Qv987Arzwyku4+eTDzCrF6wAzDEFaAzPCTKQSKMZL
 79oHMkB+/H+MU5ZIUKHNM8/tb4xggfnylmTpaIUhVN235t+eKqfJ5yzXkfSw7xIw
 p7LppbysBgu20yHOGyD+jF8owk2S8gSDpz0FYRoRp04dmx4f2UekMtj9fk3g4qNG
 2Z2qVRxpuioKZbxKZ33nR56t8x7KP13U7d9PYbaG1TGDWKzHRO+j1wb2dVhG72cd
 nR87D2B54T5A9tsk91gwlUFanBifhh8xn/HXImF/5iAsDmCZ8f+zlKMftq6Ae2oK
 A5SzUFBnzTo7frOv1DFgQu+mZuw6uilagm0W6eeUIxVOKpAZaoAKhspFcg6HtUGB
 LBx00ovum5wynuFy87UXEukZKPtVyl/bNRIeS8woKLg=

On Wed, 2023-01-11 at 02:12 +0000, Al Viro wrote:
> On Thu, Jan 05, 2023 at 04:19:29PM -0500, Jeff Layton wrote:
> > The file locking definitions have lived in fs.h since the dawn of time,
> > but they are only used by a small subset of the source files that
> > include it.
> > 
> > Move the file locking definitions to a new header file, and add the
> > appropriate #include directives to the source files that need them. By
> > doing this we trim down fs.h a bit and limit the amount of rebuilding
> > that has to be done when we make changes to the file locking APIs.
> > 
> > Reviewed-by: Xiubo Li <xiubli@redhat.com>
> > Reviewed-by: Christian Brauner (Microsoft) <brauner@kernel.org>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: David Howells <dhowells@redhat.com>
> > Acked-by: Chuck Lever <chuck.lever@oracle.com>
> > Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> > Acked-by: Steve French <stfrench@microsoft.com>
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> 
> Same question re git tree preferences (and my Acked-by in any case)

I'll take this one via the file locking tree as well. FWIW, I have some
other filelock API changes I'd like to propose, so I think that'll be
easier.

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
