Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72D5EC4332F
	for <ocfs2-devel@archiver.kernel.org>; Mon, 21 Nov 2022 16:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=7G30quZCOozIHzzAqA4AOd8/HJj+SMVCI2nVkIhhnEw=;
 b=aqpfyAnEDcPto/8fzVq/z+YIrrxb/hsHCUgDdKgg34EXLRaLEQTl9jkInHD6gBxKC/r59MSjEfYg
   hWdu0dQGhSDn2TDLg/76q9aIY4TMY0HQOdkBy8Gie8za2xITqfAC7+LZ0UQ3VBG+tLHNOErAa/5A
   ucDF+OON+aMAs6g5PfYCaFqhBgdY0WTfrtSEtW4hRresSs8+8IqXdBtQ9kprcT2e4ziIQ+eW26Qk
   C6f9C4GLvFZpqUJVCKQog1I1c1z2zFURn3scySaaxkfsqBu/1qedUzJTQKlo7YOdObLhm1GRcxCm
   UobRWa+HAzsOuI4WZunzV0Du2wQzUECHY0X+Ig==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=7G30quZCOozIHzzAqA4AOd8/HJj+SMVCI2nVkIhhnEw=;
 b=pjldiYRKUBF8RO/pwl43ZO0YSOPj0nUNJsEMaDwvaYmfBB8BHfMAHHrZkkoYYG8L4WiGFo0WGQLt
   9rArY/Sdix/mHCB2e2Km5zydZ/XG9auftZ5KriYiafXdQWbAgvmiJMZ6c2lCWsz5g2F8gilkY7vl
   46MrmMQeGEcQqaTnq4ua+rYEaWyvj84rRPd1ujGLlFpSW2GtkbtMI4zRTjGNSxjFJpZ8KE3emgOn
   WAhnI+izmBizB5GcJe1h50vC4h+7qZ4pN5SbS914K20Rj/aYwO1sVsH4R5nt7WD7dUtoOgwqoLgg
   jiTAkqMjLP1c01HLAyvr+fgv7tdrck98d/HbLw==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RLP00DBRH69CH00@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 21 Nov 2022 16:15:45 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=alex-at.net; s=default;
 t=1669047326; bh=aLypVIVXEhKOkxpV4UoHnTQ4xDimdIfxM5rQ+W67hac=;
 h=Date:Subject:To:References:From:In-Reply-To;
 b=aHeMm3qReLSPqNON05TZJ8VJtFO5MHxHoCxWTeNhErwdQ9MkrzxI8uEcnixxpj1Tl
 ODg8ZXGgb/2nBladP98SSY0LfVBjxlcxj0QO0twUGSlReUzw1JnFE+pLnxe98FLJIm
 YMQ4XOsp9tW6WKtypEtEvwk+3KgE5nbgi7P+JB/8=
Message-id: <53bae0c2-7e20-4b16-9c7c-4fb9e617b9c1@alex-at.net>
Date: Mon, 21 Nov 2022 19:15:24 +0300
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Content-language: en-US
To: ocfs2-devel@oss.oracle.com
References: <d7a1e5ae-c43f-5a6a-c0c6-619a3e22b092@alex-at.net>
 <911762fa-8fc2-ec01-e767-1ed8ae7e5c38@linux.alibaba.com>
In-reply-to: <911762fa-8fc2-ec01-e767-1ed8ae7e5c38@linux.alibaba.com>
X-Source-IP: 51.195.137.138
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10538
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 unknownsenderscore=20 clxscore=-126 mlxscore=0
 impostorscore=0 suspectscore=0 priorityscore=1501 adultscore=0 phishscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 spamscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211210126
Subject: Re: [Ocfs2-devel] dinode link count inconsistency in
 ocfs2_read_links_count() logic
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
From: "Alexey Asemov \(Alex/AT\) via Ocfs2-devel" <ocfs2-devel@oss.oracle.com>
Reply-to: "Alexey Asemov \(Alex/AT\)" <alex@alex-at.net>
Content-transfer-encoding: 7bit
Content-type: text/plain; charset="us-ascii"; Format="flowed"
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: mail.alex-at.net
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 a mx a:home.alex-at.net a:sphynx.alex-at.net
 a:mail.alex-at.net a:mx.alex-at.net a:home.alex-at.net a:sphynx.alex-at.net
 a:mail.alex-at.net a:mx.alex-at.net ~all
X-Spam: Clean
X-Proofpoint-GUID: iecBbeqpeOzCeclqANgmLHktCi9XXTBs
X-Proofpoint-ORIG-GUID: iecBbeqpeOzCeclqANgmLHktCi9XXTBs
Reporting-Meta:
 AAEWEoocZqILAdbmaueaTEkvt8LIfdrBGnNg2gf8qEH8EIFJDILjjJokGjukxVVZ
 YE9Bt1/5zt6niucOzOnBKN77rQipWsfPyZkJvBewQrUGs4CqfuiUwON9MEpBKzah
 sgXHOajBvp6QpbaAda+7VVBv9DtolU/jDuiU8vJZKU9bZNrY6vo7IrSqOGS2u7T0
 pOtdvuDDFRWCZeV9kwD0cFLfrOM8K7XbL9+GURqyK3HXZOKdCswsVMoCgASBeG43
 zqlv8+XMslgDQUtKpR/54Y5Df1VrfGNLcLFFR90uIFZi8uchF/ko0lhNYefsQfxm
 G8NXWLKSo1qsLpr5D3KNVrv5io6vlMtm5RI+1iS22ISUZfGNlKtKQ19hcieF6e/D
 CHQWoKZPewlCfPGMDFvwIVG7/6qPuY3W6KOToLZV4WMS05V5M5X/0LqaFJoJu7oq
 y+Tx/11DnS3kPuq/+/u4qDsYtzGYn5lc/Ef6GGPH3QlEKvg8NOY7oriu/Z1WHlr6
 DMUHGQixTzUKohVmh93Rq/fm1fkfbrNnuSFLoUdBFy/S

The modification I mentioned surely fixes the thing (well, obviously).

If to reproduce, trivial as well:

- mkfs with indexed-dirs option (otherwise low hardlink limit will apply)
- Create a file
- Create 65535 hardlinks to it, stat will now show 65536 hardlinks (that 
comes from local inode cache)
- Clear inode cache (for me cat 3 > /proc/sys/vm/drop_caches is enough) 
or reboot
- stat again and you will see hardlink count = 0 that is the result of 
actual inconsistency



_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
