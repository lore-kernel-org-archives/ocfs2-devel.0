Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 796D5C54EBE
	for <ocfs2-devel@archiver.kernel.org>; Mon, 16 Jan 2023 21:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=wr/6hmfmVFqejDFh+T0/ypzr5k7QoQTMU1NmrNbO4Rw=;
 b=ERd7klR3rYvXzOYSzd2DIT6FXUS0KJcEujM0rtp3DvvVWmlsMF0iZtUCN6ARgkhTH6tPxP3M9D6o
   ntME7/LFJduaMd99Gks8bQj7wLSCvdjep6QEkZRlwMzlp7/P1+Ea8ERelg/RGAayk/NKdwwxQO1F
   TPV0xyK4noq7825nKzvEpcEPSLzp0xOxZQ413QI4kQtRuzmj4QGPgacM/ynfp181lofXxd5IchOW
   SAnLoGMnVT9wH6+X4TWKyPexAbmmgwud+rnqSvXurwOIs+1AbXSYi+G4FvqiB6qGeJfjYbig5WsT
   mOn4uvTQwV6Fhe22zdLjh75FHLgbK1Ohh0ojYg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=wr/6hmfmVFqejDFh+T0/ypzr5k7QoQTMU1NmrNbO4Rw=;
 b=AgwAtLJx3P79VQni8DCqd9CPGfr5t3UgFhasfV1DuJtyWfPnHOqHJ11Fk8ax5ZBU0BKphEAO65Hf
   solrCw/F0HWcJ89wTb6eZWOmWR/CTbJC+FAPk37BxMMMHdxbqZnZnpfqGIoKHkuppE8VfbmmFj6K
   3LUK2cO7htZlePkwhMs56tWlnlQhWQLw/ZyiW+4uxiD1s4Blhfadygvt8J+2eif0N1+HAJE+dhyh
   YB7qkaWtWVVDuO/tFU6B/QCAN1hQYrRXzV6vfu72BJYdvew4MULsy+Uju+N2QYOnd3j1a9I75LLX
   LZYMm8HOgWH8qeaje2pljusCuU/Y7KfLMLjwVQ==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0ROL00CHTL2SQ1B0@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 16 Jan 2023 21:30:28 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
 s=korg; t=1673904612; bh=bOzsQfQw6tO0Vrg+XKg+pWo7df/w9dC+JoyDrq7xnUc=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=bgXfNMU36uKZT7YZ1i6nYhE2c6rZ4GzVadzjYwR4Lumg23b2RtJAmH/i0pA4SITZY
 mMF7XOKHOrELPoBWBaQEUVPmyu2SwIkmSuTZtTRbw9Eu5H+NOHE6MECgq2PpDrdkVP
 a/Fi/PXyWgR1p8DIfEl8lCfqlkndZmXHhRFNeTsY=
Date: Mon, 16 Jan 2023 13:30:11 -0800
To: Al Viro <viro@zeniv.linux.org.uk>
Message-id: <20230116133011.81f6e4e42805ed47aa61270d@linux-foundation.org>
In-reply-to: <Y8W7dULuW5oFGm/J@ZenIV>
References: <20230116085523.2343176-1-hch@lst.de>	<Y8W7dULuW5oFGm/J@ZenIV>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-version: 1.0
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10592
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=206
 lowpriorityscore=0 bulkscore=0 mlxscore=0 phishscore=0 malwarescore=0
 adultscore=0 impostorscore=0 priorityscore=186 mlxlogscore=686 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301160157
Cc: Evgeniy Dushistov <dushistov@mail.ru>, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] remove most callers of write_one_page
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
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:140.211.169.12/30 include:_spf.kernel.org
 include:_spf.google.com ~all
X-Spam: Clean
X-Proofpoint-GUID: lL_ZNmei35OS4zB0OpNqmahemRxkVw-V
X-Proofpoint-ORIG-GUID: lL_ZNmei35OS4zB0OpNqmahemRxkVw-V
Reporting-Meta:
 AAHwd23mSQJeAUl32FcyOAjC/riz20pIQuJp0VVXMjpYQTPyual33VBA9DDX7uuq
 /qtvPaj/2uBN1kyhZ7W9NlfxlY+XSoHT6DqfwgAFahTHw+CMy9OMepyUJADZud7U
 hBDrSvci/Ge5OHsHz1z0o+TmCYtQg+LOrVE0ihEyTACrD+6a3KcvgQRMfAwCItlE
 YPRxNmD8EF4j7U2kV779LtfxvJUMLp+++/DHO91WiEgHkNH1J1xer8tX5ztD75a1
 NaVTR3yS8JuQcxeso3Ic/EM/V4GKK5m8LLEk+crqH/ZBdk8QsBRac8cxehTygnHJ
 IbtuSEkdrinSmF/9NFX7/1/5YqtGUkD7/BaMUf29QgSCqE2Usv7ohkWsfMcycVF0
 zUAZkz/iDrOCUhoS2/0kVO1+VCq6+aqB3lgc4IKR7z5UlLLLMYajJ7V4g5cZfVR0
 HZr+arwUf8LRn8S1r8RzrlJmzugDG6+RT0emNo37PynfPMqb1wNWT+k4BmR+a7DQ
 N6Qi8opsrznqu4cXT1RL/fqhzSvBbF6wgKMlLXXgJvZU

On Mon, 16 Jan 2023 21:02:45 +0000 Al Viro <viro@zeniv.linux.org.uk> wrote:

> OK...  Mind if I grab minix/sysv/ufs into a branch in vfs.git?
> There's a pile of kmap_local() stuff that that would interfere with
> that and I'd rather have it in one place...

Please grab the whole series in that case?

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
