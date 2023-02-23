Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CD12C61DA4
	for <ocfs2-devel@archiver.kernel.org>; Thu, 23 Feb 2023 21:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=uj2mwMOZ11bGt9NdCuDKtHcrB+ktlYfEDfjIQY3T9yg=;
 b=DMYvUBYFQ/18rZ0e5NZRCKebH6Gt+u0jyjMjyu7/RFupwuwgw//U+zXLZUQ77quD6j+G4iKAgva2
   bEDA/HyLZJKEzfd7h395TOt9eC/RFYfxxQa6F1gTUU7AIDmjQBHujeg/kO+Azsm/CeyRn60HeeHt
   T4X85dYsCozCwsJ+YoNsjc1ws7ZKm8WGIw1kMHamsst6ZJXpntZqnTygVU5k1GrHUiuheONR5RAV
   Rz9PwNEnqeHiEiHD5wFBZmUgy2XM6+Z2esmurdHtMvhPuoH/5VejiYGFm/SKpqRLZCbUqSXyfDVR
   sdNhgcnXUOUmZ5Gvan6Trbl7D2h1vbkjUNQmEA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=uj2mwMOZ11bGt9NdCuDKtHcrB+ktlYfEDfjIQY3T9yg=;
 b=oMlvbYeTjRRobXqihjdcnbB45uT+P9dDLIq7tMdu6r0Zc0DeDmcJ/6ALmm9eEMZKpEuo7ye8ZIe/
   wAuyhBtoqVNorwWtaLIFvzhKm4mTriIzdZrK0qFxuJfqT1HwLKTm8GomeEiayF/yi5+TkcS0t8Jn
   auTBBvXDsHUM6LGrda3LjZ4+fK9a9yei0GCjm4UjsDZsNEUfiUcvlqPAMHk6Sn01CvpYg8FIjo9C
   EK+9MkknDJWJ2leCr5j4d9XX7UPQz7z9eDaFre6nSnQHmoB8EMJTZYv1vFFW5WBArGSnuoTx7VwU
   tn4ZFTrKHUhuZfbOmvjFMnPN0dmKdF3xrO0W0Q==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230206 64bit (built Feb  6
 2023))
 with ESMTPS id <0RQJ00CQEXCLT0E0@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 23 Feb 2023 21:07:33 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
 s=korg; t=1677186436; bh=2ijMJsAlPRx75Ae00EmHwJTpzrYaKC6DtB0cme4ikyw=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=PHXgNepNQGwMPNt/WN12yxE5deBpBvqCXF646IJWEwpMPN7TX6zci2YZAiCsjI64l
 eNxra+YmwMRZsRbki2LQNWjbBfhA0Iz26NWzkCodF5U6jS82kaiNZrYUh66BGFtBkA
 L2Myhk1iDRn7JNsKAqoXR5HwszNeVb1uo0K3O7Ms=
Date: Thu, 23 Feb 2023 13:07:15 -0800
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-id: <20230223130715.8df852c1630b9103097489ec@linux-foundation.org>
In-reply-to: <ed8df998-b9d8-bfc0-e590-c54ada78cef8@linux.alibaba.com>
References: <20230220050526.22020-1-heming.zhao@suse.com>
 <ed8df998-b9d8-bfc0-e590-c54ada78cef8@linux.alibaba.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-version: 1.0
X-Source-IP: 145.40.68.75
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10630
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=182
 mlxscore=0 lowpriorityscore=0 mlxlogscore=826 impostorscore=0 bulkscore=0
 spamscore=0 adultscore=0 suspectscore=0 phishscore=0 malwarescore=0
 priorityscore=118 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302230174
Cc: ocfs2-devel <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH v2] ocfs2: fix non-auto defrag path not
	working issue
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
X-Proofpoint-GUID: FLdfpgqF8ipCOeaeZEZXuD2MEYpvPBbG
X-Proofpoint-ORIG-GUID: FLdfpgqF8ipCOeaeZEZXuD2MEYpvPBbG
Reporting-Meta:
 AAFrjwlPY+bQy4ArmBE10+AQ3aPLlxVMu6XNY9SZQ+fxPoSXRmsjHXa4PXampq6r
 WkhKAyH4cOyGC4TwiAWAPnM7i1priGmKJxJ91VR5r/cWBeOh4Db1dV8lESA40ti4
 dmGve9Lf3L6+bUhvSqX064AEUYEBvqpjLA11T8UvhzeMBwDf3mHfDUSKRKMnbTNM
 mq0J0bngH3z0cI8ZwYidUlVSCK0RUV9bHCuIBNwh/8HavvC/eco013QdfXEi47YG
 Rfb69YhOzqbD4mH2H62CFufDk4tUJmcxkfwPDuX6DukIBb4D9PKErLQqxzyl7e9w
 FegnjJ/9NRGQ7i3R2AOrRdc66HVaGyV3GfzDnUx4glcH3urcRQ3g+FXrEs42T4/7
 BksftWEqHkTnhwZ+P+cNKPMjYDcatn8SY7FuQQBrWTvCU2zkyVWPlGAi78ho9FtB
 zwOFUXyZKUvDcaFIx46Ci8yNckIfYrGItRpiC50IYiAe+gcHiNMdbC4Snp35fDnm
 tI/wXGCsY0ZNpuZ51anx12ZRXJwX9/JH97ogDPinB7o=

On Mon, 20 Feb 2023 14:26:19 +0800 Joseph Qi <joseph.qi@linux.alibaba.com> wrote:

> > Currently there is no tools triggering the above issues since
> > defragfs.ocfs2 enables auto defrag by default. Test with manually
> > changing defragfs.ocfs2 to run non auto defrag path.
> > 
> > Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> 
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

Thanks.  I added a cc:stable tag to both these patches so the
fixes get backported into earlier kernels.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
