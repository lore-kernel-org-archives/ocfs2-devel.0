Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D2BEC7EE23
	for <ocfs2-devel@archiver.kernel.org>; Wed, 31 May 2023 22:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=mWNX74atQD7ZcTsNuHyNd+khxnx3onDEs+8V7Yxwc/w=;
 b=dEVDGKfEDlMqrlRxpLUkEmwM9BDzFURElyxIMOSGjZocp32tF9eVCXYijphmeIWrCG6a+QGzkkxl
   zH7BkteMTjSPFM2UwjlMmsHiMp7kw++xEV155vl+x3BWtfBUFqGkhfqBHto6ttwqHBJxa7ZH1RAK
   ctdfQfkItb+EuvktARkjb25G0a82S2rsxfpI2Oe/HeqIAyd/vqyDjKEIzJHGviJhTVfK+8dgf0wb
   y/BX78DYn8VgfgbJVv5v5IfWejEK490mBsLOEG1IAq+BlbRV04K4e47EBWyUwgw7CUgjwGQ+l13P
   1E+OsuNMj1u0BUnu+8T8ABRBbtYUyUGxYZWWQQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=mWNX74atQD7ZcTsNuHyNd+khxnx3onDEs+8V7Yxwc/w=;
 b=CoPHdR6RgB5RsedBiFyuHCZixX/TC5c4Kn0fSsB5jew6VfNfaavfCt1NUbz5y6PMOUU3qMytWlX9
   d8jDPRtY4VaYSLZY3Nn0B3xEq8TXSTt0HuidzIOzNY5h/Jrwtp68cOU6LdLMeIHSOn2f+a3HqG8Z
   BUtrlDgxRKqBQEGHQW95/fXdIjToPnSd+ndgGgg/unQws1eoWV41F6prPYVmiqcLBALIQCbvJcor
   lUEhpZQbN4iWswgK94YffiT1ZhU/ksGHXQzrJIW5UqyFT2etb50au2YAVKn6WNuytjfmBA1N+B9U
   0EFY5Me3Ci0AKPIC86wEyMwB0GVaqMm6iD5R9g==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230522 64bit (built May 22
 2023))
 with ESMTPS id <0RVJ00723N04UN70@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 31 May 2023 22:12:04 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
 s=korg; t=1685571108; bh=Q3O+YfTi8ZwhCNuCN0xNiOxst69PRRr66pHSmYOzp1U=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=sH7XXkPri4OLA8eYaGe6mlFtbTmTfWJRgdLV4scGrBIX/t5996wccgLGVkfiDj6H4
 v+NC0hMlKUTUMgN1tnClGHtXKzsZ3fiYLCPfcFu8RcFtJ4tJ7kAiZvgdnJ0LL2lR36
 IC8jOSIz/ccDKBVkwumZg7geS4XMZPWgDO15k7WE=
Date: Wed, 31 May 2023 15:11:47 -0700
To: =?ISO-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
Message-id: <20230531151147.3d98aa2fb1d7f659bccef37b@linux-foundation.org>
In-reply-to: <20230529152645.32680-1-lhenriques@suse.de>
References: <20230529152645.32680-1-lhenriques@suse.de>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-version: 1.0
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10727
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
 phishscore=0 adultscore=0 malwarescore=0 suspectscore=0 mlxscore=0 bulkscore=0
 mlxlogscore=999 impostorscore=0 clxscore=208 lowpriorityscore=0
 priorityscore=30 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305310187
Cc: linux-kernel@vger.kernel.org,
 =?ISO-8859-1?Q?Lu=EDs?= Henriques via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: check new file size on fallocate call
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
From: Andrew Morton via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Andrew Morton <akpm@linux-foundation.org>
Content-type: text/plain; charset="iso-8859-1"
Content-transfer-encoding: quoted-printable
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:140.211.169.12/30 include:_spf.kernel.org
 include:_spf.google.com ~all
X-Spam: Clean
X-Proofpoint-GUID: DtsNbkuMaTqYYqSq05LAZtQybplxGUzK
X-Proofpoint-ORIG-GUID: DtsNbkuMaTqYYqSq05LAZtQybplxGUzK
Reporting-Meta:
 AAFNa33lxACYXqfgY0KEdXlCZFL+rk5vl0C+2kfUAxfS4fRfq8XSOzmqA/sS+L2X
 0MZr5P56QX8Bp1eSEA1t398N+NxUVS/6DuTy2sUDRqaNBjwbXw3kj3/WP1bjbnI0
 cj03BkBl6zYFtyd/aQiacOD74Y1NRN75BFenqZKffhFyPAj2avqhqxlDL0buQbax
 mhsVB81VTJdmxH+iz9kxNOhdvUa00YLKDmsUgUyqFuwxEKIzyqCrbzcZd1XDXOps
 X8ikAuMLHmXwSjsbmwfF5kh6wkMDfGyQhUJ2Ck1UHGFfFP+tfSncTXroRPzRGYzF
 ZigjP1zQU0HqEIOMnR1tYlRifVsCxix5DivO+c4YSbO8DXsxeskuGds+OYfV8gqI
 NwzuN7nisoqarA6C+iAMdswcPWv2cMVq3Opzckl0Oz00UXfmzt4ojmarg5mZo5FU
 LlswBx70ZFlNdG2ZJzR+6ARXULCOroydst3SFhF/7fXEcNTYw6yP+7ngefABL8T5
 JkZI9hLmRzsE2HTZGBI01Ki0wvQ8Zx4DJ1i4AL1Ruk4=

On Mon, 29 May 2023 16:26:45 +0100 Lu=EDs Henriques via Ocfs2-devel <ocfs2-=
devel@oss.oracle.com> wrote:

> When changing a file size with fallocate() the new size isn't being
> checked.  In particular, the FSIZE ulimit isn't being checked, which makes
> fstest generic/228 fail.  Simply adding a call to inode_newsize_ok() fixes
> this issue.
> =

> ...
>
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -2100,14 +2100,20 @@ static long ocfs2_fallocate(struct file *file, in=
t mode, loff_t offset,
>  	struct ocfs2_space_resv sr;
>  	int change_size =3D 1;
>  	int cmd =3D OCFS2_IOC_RESVSP64;
> +	int ret =3D 0;
>  =

>  	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
>  		return -EOPNOTSUPP;
>  	if (!ocfs2_writes_unwritten_extents(osb))
>  		return -EOPNOTSUPP;
>  =

> -	if (mode & FALLOC_FL_KEEP_SIZE)
> +	if (mode & FALLOC_FL_KEEP_SIZE) {
>  		change_size =3D 0;
> +	} else {
> +		ret =3D inode_newsize_ok(inode, offset + len);
> +		if (ret)
> +			return ret;
> +	}
>  =


So userspace can exceed rlimit(RLIMIT_FSIZE).

Do we think this flaw is serious enough to justify backporting the fix
into earlier -stable kernels?


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
