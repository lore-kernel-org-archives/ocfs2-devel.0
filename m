Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71D2CC00140
	for <ocfs2-devel@archiver.kernel.org>; Sun, 31 Jul 2022 17:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=vWcBrO2qql5fiXEQCgRjI1U7ZYGkvY3mvG2bWdEpVpM=;
 b=1Mkw+oSsi023VtHZDINROud5e+SOF64T93xhGrrqXLlpgCXD+Bi2OgNKNXxbx9X0D3GOxOM/Tanc
   8S3X7LNVJj+2wxcNrBN2gEGZY/mUD78YSibJhlNm0Sa5QVglzHfEDOlE1DceQuHA8jmR6uQDrjkz
   h3+S0dn8APAnhGZIvMc1E+/xD53zTNyq3953yuKKstNq9vM4fMhUQ0kqJ8M9wahcsMQYOCnz5AVD
   JKyOJwI5EMZCnw0NVkmEuWzOZQ369c/AmtbOyM74dQy3folK6foyNu5nL3QZDwkyEikWrxFrUTA3
   vqWu15Wy56pFXEYobjBHjJlmVN+FySx3Vd4Ang==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=vWcBrO2qql5fiXEQCgRjI1U7ZYGkvY3mvG2bWdEpVpM=;
 b=R75wOQVZN3B991iT2Rc0QceLlerNlh1BCEsXmw761m3qjC1IlcXkJwhb+MUs+4Hnx1ht1T6tPRHj
   SPk/TogNxfER8Grn7LsqVjymZTJtkU2Aq9CTYoj1DCGB421oNGDj9ZOspgqVOVhRRF56dvVsOuKY
   PrV3Pln/qKk9qGTmYB+GFC8j7XBL9l3ovzQY8YdKwjX4LjelQH7N8kmQkeVD2d6wNaaz8Zos6MTP
   Kl3JGt7TKlfjecZVshl2Xdn867bkPJJQxL1iwhi5ngxbJWMty7F71FRYKexDHpDBuwqOsOdwiNwv
   fqkYqx6oX4/0i6mJ7BY4fs5O5QIJU5jvQdFiIQ==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220621 64bit (built Jun 21
 2022))
 with ESMTPS id <0RFW005SJBVQ0E70@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 31 Jul 2022 17:43:02 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fasheh-com.20210112.gappssmtp.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc; bh=Lx1qpKuOgo3HeqPjXeZa45vjS4z2h6L7hwebtgYy12c=;
 b=P9TbH5NC0du4T5A7B4AKTel8YpLtwsVM5nfGpoFkAGRcU+A6kXHT3HMQXnFwb2IEUf
 ZoIuw9qA4tA+oUyHewL6rOl9IbTa5QqqA7aLVwgjq0N60YKy3i3alH7NkJGPkq0dg9rK
 0BOaE7e+uY6jlhIFZHS4Tz+sx09aRQCFWPq9njl8VJNG4gESE47pmotqIXfsLPJnp7kV
 w2ShE5IiOCRteUz1iryMT/uv1jWnGOKduR4seaVoCWvlC5WER7wqCBxp+G43yAkMXukb
 YStzpH3uQEvZJM9lkw3izq+PeHUJbZqVc1FzBCip5rWVs3SYlwkEKqsvmv7LWJhua63M 4erQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20210112; h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc;
 bh=Lx1qpKuOgo3HeqPjXeZa45vjS4z2h6L7hwebtgYy12c=;
 b=tr8AGoipF+wK8cmoxqpQlvcxjPl551aFzaapBnjjXAxEjkHEGzwnfLILAPqPGXFEZB
 0h2lLg5TCf4eVJz4FS2c80Vmv18blGWVQ16DCF6G38E2QsvDFaFqMX2q4zppvdNnpJsD
 hDRG6Xvi5xtYWfDP4C8+zcPvSNx7wkVBFDB3BujGtzeWfVihoUzlVVZlcz3WmFXXQv7w
 qQxlXX8KhCxWmrw2uizYl4zFGJpYlVl8FIaZ922QGTAgAtIvAQ3BDPgGTOeg2Crzb11W
 ykud4YMURm74cLtWElfqgy3Qk/7KCuPhTxbEAHPIxlXtfJ2HmYFf6ufH/vHp5psMGJYv tNRw==
X-Gm-Message-State: AJIora/NAbHwE4cHwbKHadwETZLqHcob8vn+cw+Rsu59c/z0miZakmxr
 5q2ipK/HW8Hp+cK4dAM/PJPr3tow2/M3eUkSpnN6kA==
X-Received: by 2002:a02:c722:0:b0:33f:393d:d198 with SMTP id
 h2-20020a02c722000000b0033f393dd198mr4938110jao.22.1659289368187; Sun,
 31 Jul 2022 10:42:48 -0700 (PDT)
MIME-version: 1.0
References: <20220730011411.11214-1-heming.zhao@suse.com>
 <20220730011411.11214-4-heming.zhao@suse.com>
In-reply-to: <20220730011411.11214-4-heming.zhao@suse.com>
Date: Sun, 31 Jul 2022 10:42:37 -0700
Message-id: <CAGe7X7kLfsUfb1+yYgD4PffnJYvJVeqrLtub8qC=ujC2gxEzTA@mail.gmail.com>
To: Heming Zhao <heming.zhao@suse.com>
X-Source-IP: 209.85.166.50
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10425
 signatures=596356
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 impostorscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 priorityscore=70 spamscore=0 clxscore=190 lowpriorityscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207310087
Cc: ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 3/4] re-enable
 "ocfs2: mount shared volume without ha stack"
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
From: Mark Fasheh via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Mark Fasheh <mark@fasheh.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Google-Smtp-Source:
 AGRyM1vCbpF7Uy0rvqikTOLROB6CHep/9cuGtO+De/ApiXYpOSY79DkrINGAv76kur93eVwVSq3yxirBJn8EJ6eb874=
X-ServerName: mail-io1-f50.google.com
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-ORIG-GUID: 6sMkanjseKrZMwAXfK6dFLN2eiIGPDcC
X-Proofpoint-GUID: 6sMkanjseKrZMwAXfK6dFLN2eiIGPDcC
Reporting-Meta:
 AAE8U526rudp2Z1U3xYhqEioK4j9KFvtngRBOz67dL3lCzZq+aQ6WVoX4/gdapHZ
 AB2N/btNUW4x6gr9LlWwn+LOJgbYN2MbyK43dkIbl8apUj/RJ/ZXi4ZHYDaLGkcg
 54ATLABjOlQEB0Iv8fsMgEFEHbKVi68zV09eUmzdy0743mhRkTASexsMlKy7ASYs
 S27buCpoBcerbMkWl4laibrdHfvJKYtVKxp2sR4oqhsykpKlkAx1MzgvmMSqBBvq
 nxceXkrDyeovdXOANKnt2BJ75cD5+a6d0OHMAuhACXcevK7ehyGhKIUOW2Xe4yA6
 RWfYXRl+W+H8/Nomd8jjHyyz6Jlp16XkTgt3bO237cVnxdjDZB3srkq9zrHw2Oi/
 Zk3UTu6KjX0RgcEguNtyr2jCaUPdJGRD2GRhN4fjCpEyOsmeyV6fbpwwzsgSsKOC
 9utQczGUs7q+39eOHnZJWxTXUl+gfEc1jFEhoda3X7Cs3NpsaqHvYt+pqsKNR8a3
 OYYyzPP+8imc8SXsMlCbLHX6fMH4H/bxq6f3MzsAeY0J

Hi Heming,

On Fri, Jul 29, 2022 at 6:15 PM Heming Zhao via Ocfs2-devel
<ocfs2-devel@oss.oracle.com> wrote:
>
> the key different between local mount and non-clustered mount:
> local mount feature (tunefs.ocfs2 --fs-features=[no]local) can't do
> convert job without ha stack. non-clustered mount feature can run
> totally without ha stack.

Can you please elaborate on this? Local mounts can run without a
cluster stack so I don't see the difference there. We have
tunefs.ocfs2 look for and join the cluster so as to avoid corrupting
users data - that's a feature, not a bug. So what I'm seeing here is
just opening us to potential corruptions. Is there a specific use case
here that you're trying to account for? Are you fixing a particular
bug?

Thanks,
  --Mark

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
