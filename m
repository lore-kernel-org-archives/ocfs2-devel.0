Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F25DC4332F
	for <ocfs2-devel@archiver.kernel.org>; Mon, 17 Oct 2022 02:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=tgM1TQZeqwC8++Tw8jKrDhWRL6MpFUh0n17R+PEiXbs=;
 b=cXo0zWuiaoC1M/zxi/PTp/bH584yxOUokzvDrIi5Czww/2a7bvUeG5WtOvOEmA0o3TsK04D2AGqn
   O2CTInHRg+FHH+evAAQkkAatBq38Ks2M/oCdae3EEcqKCpY+hUOoHeKRCbb1Wet+Mmcrd/GnDXlE
   FHe9ZA23ShUMqL+FkjbmE6UKc1mu7kD2pGqbBy5Hgtl5FZYnP+RreRdLaNeW5F4SFMW/sI/5H2Ki
   UTcTDFaHVwTaJHX1P3wbA/qZ+eP6m9CfYF4Gk+RrlmmKiy3MSpb4Hx2FxfvhdCLYIkv6XxdcRdUd
   NYOzTzzGxg/3Af0/JLorXFiKj4+zqZd/MZq69g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=tgM1TQZeqwC8++Tw8jKrDhWRL6MpFUh0n17R+PEiXbs=;
 b=J/kR/8+1rnp7Wxlo79dRfd9TSJDSMYBo1ZlQWVEODYsuLJE4ATjZM6VE/tO042yCt4ZC6wO7WseV
   wcS2st+vubGpQa7azP1D65L49EL7Rz+fhdjA4fUzKlqEcpApsEyjHHMxHa6bslI+UeYsND6HcYzh
   MYr2Dwgk0IqgMbZLTCROedt2KRGOPItb+1YXY+Lvi8yZbPG0n+yxpqLI9cTfkXDyzpc4Q06e9yIM
   uP/9OM6ftU+/oWGiOh2EWxrsKZ1S+PnzVc3HW9oJkKFG4nymvJHSKrrAbtAACYqjMPOi48ZbyIE6
   NU2PLfYLhWA7aSVvAVLNQCCvJHSwIskHDeD21w==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220914 64bit (built Sep 14
 2022))
 with ESMTPS id <0RJV00N1XLKUAOA0@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 17 Oct 2022 02:29:18 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
 s=korg; t=1665973743; bh=jsK3qEANRyPmKldiqe7w+EnAwbL36O8N4IwTdPMdRJ0=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=gc5KnyyetB5mVmEtwZOa+ZpMS4OWiQa413XQbPSysavRW07fvPr8ZZMP4fF2dvzIT
 CrJ+ic+eyoAs1DxGaxANoDZ9OFhG4X3tdPS/Q4umCXzUi6xwjR2JZLCFu+pebIUdok
 uA1b0kCJvpC5TXe8cEG9dTgrr8ckLBeg5ioVarJY=
Date: Sun, 16 Oct 2022 19:29:02 -0700
To: Joseph Qi <jiangqi903@gmail.com>
Message-id: <20221016192902.4d7e70047ca5d04a2f585688@linux-foundation.org>
In-reply-to: <06a7f382-5eaa-9489-3c28-aa4bfb804327@gmail.com>
References: <20210729110230.18983-1-ghe@suse.com>
 <5821fd0f-2018-dc1b-a5c0-f948a7debff4@linux.alibaba.com>
 <c7e1f0a7-e75c-d1e0-870d-dc480d070079@suse.com>
 <71608a14-58f4-dba0-d695-fee65de89192@linux.alibaba.com>
 <801438f5-655a-c708-aa25-343d54a2f11e@suse.com>
 <86e3d724-3147-ccaa-998f-0f857c575f7e@linux.alibaba.com>
 <a0a9710f-461a-99c8-92f6-a99bb11b3a4e@suse.com>
 <4ba3b404-824b-90a3-ef43-9ab6510ee073@linux.alibaba.com>
 <5a1af56c-3eab-5baf-62a3-1c98bac104ba@suse.com>
 <db7119a5-f120-cebe-42a1-dc2f64db620d@suse.com>
 <20221016162950.09db2b5f503ac87823cd1687@linux-foundation.org>
 <06a7f382-5eaa-9489-3c28-aa4bfb804327@gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-version: 1.0
X-Source-IP: 145.40.68.75
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10502
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 suspectscore=0 malwarescore=0 impostorscore=0
 mlxlogscore=570 spamscore=0 mlxscore=0 adultscore=0 phishscore=0 bulkscore=0
 clxscore=111 priorityscore=160 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210170013
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: reflink deadlock when clone file to
 the same directory simultaneously
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
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: ams.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:140.211.169.12/30 include:_spf.kernel.org
 include:_spf.google.com ~all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: HHfTlDgdK8b2WTxWlXY3Pjaa-6XjrGRz
X-Proofpoint-GUID: HHfTlDgdK8b2WTxWlXY3Pjaa-6XjrGRz
Reporting-Meta:
 AAHxsraBCyLUS52CkZdMzwr3jSqWZCkC1Ug6JN6zptNpzrLXjZbhAUOEQC509Xm0
 PKp0hmwflrfYtdUolNG1SrdMDjlkHftmDk+Yyd1JckzrBgjUmsgZMJ3RibM5Wahl
 tlGht5Lq/1dCV5GZMyqW67sdE4t7uGyQHWWYkh1xOsQvLkAJ2tK92c+fYgD+QtoE
 zde/sCuafeVmk19s+JzLSPzARSeXCOXofe5HwAYQ//8E/vxoXzZ3s2J2TsrqHHTe
 UxO8O1Ajda5hq+WHuQp3DRROkY2eTWy8uONeyPNQ4oxXnrIpSNd6l4YH6EuJB3kY
 nk0yhZMLURwpzNrkA2q71N2EhRI1BhZpWdk7NOCQGTOndzXYZRp9OPDnmpeF6NAM
 hk7V7rQ1VickRswcl5ya2EJFmNcSWPBNMxT/tXmz1bAr5YLPMroFOJ6oU8UanIUH
 /WIrad25kICMGg2FFo6w9TdEFyfMV8zfoPmaBN84MQnmGYiOZ0CIwzzJxHwUxiAo
 NyI18TG/Ge2UTiVTcPoYEthPcqLP4Aw1lInOaZvQF3c=

On Mon, 17 Oct 2022 09:51:14 +0800 Joseph Qi <jiangqi903@gmail.com> wrote:

> Hi Andrew,
> 
> On 10/17/22 7:29 AM, Andrew Morton via Ocfs2-devel wrote:
> > On Thu, 26 Aug 2021 13:56:16 +0800 Gang He <ghe@suse.com> wrote:
> > 
> >> So, I will send a new patch to fix this deadlock problem via dlmglue layer.
> >> For this patch, I want to change the patch comments as a reflink 
> >> improvement patch.
> > 
> > Did this ever happen?  I've been sitting on this patch for ages.
> > 
> Looked back this thread, the root cause of deadlock seems to be the
> asynchronous of fsdlm handling. So this is not a right fix.
> While for the performance improvement, I need some test data as well.

OK, thanks, I dropped the patch.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
