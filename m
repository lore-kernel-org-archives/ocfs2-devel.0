Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3AFDECAAD5
	for <ocfs2-devel@archiver.kernel.org>; Sat,  3 Sep 2022 11:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=QRWe7mw5lE8mUDRzC67pT1JeqN+C/hNh/HC1kCjGdJY=;
 b=tPu+TpMxAN7pLN4bSk7fVrg5Q4492ZLNfy2z8YjQzNv7h4navAGtVuDD2bGxjPHnu/xJA1sF+6rJ
   MC5rEZ8J1hcSB2lKytPDM/hT7wIcbzUsLH8IeAKiP0jnkH88zOaODJybgRJas87a9oFeIN5C2c8N
   pr4yWhfOe4PK0JU7njrXyM5Y7Y5C4+inXYVSOlpcD/vfXI7VB8TIpD1no6EvjQ2Il8U7+hxtwbvj
   5qE3t9uPmkFlGmeBzL9WfiQRo0ImKbRDz2Zn6vbhJvyP68pvkMpC/h+H1Ocuf1RgOzM330uYsFRD
   bGtN9TDkmizahk6cIp08MyqT7U6VZLDyGfPTRQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=QRWe7mw5lE8mUDRzC67pT1JeqN+C/hNh/HC1kCjGdJY=;
 b=XrgDAOSCbm6F50Vdd2bFVjV7V8V1hd0/dRZd4qTjvsWKfkYrdOYg3juLKtibBHb2Zpb/An1NwMx0
   r4j/ULlnZMbB+xZ8naQshCi5T2Jgyslg8yUFIui8PmhrcDpjxKj1Bx7b4mtc3waNOIs7NZ/TNfj2
   mNtYvDzNfOGrwetg3IOqtHJqDcPacXK+Y6tuSqKxiOYIYza6m4CnMHJAEbe/Q56njrMeSxks+4QQ
   WCpTFxE7H0jD+R9BFQQanVQ718q8gKNJikL13VO0BWjd/UkDXJoklzL+a7LXux9wmZvnwlag882G
   tPBjjntBnU2JnbZxrjL1wrETozpJaCOczshgIg==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHM00F4UU5VQR20@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 03 Sep 2022 11:49:07 +0000 (GMT)
Message-id: <a3b32e71-a345-40d3-feee-fa4c5aab42af@linux.alibaba.com>
Date: Sat, 3 Sep 2022 19:48:47 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Content-language: en-US
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 akpm <akpm@linux-foundation.org>
References: <YxKY6O2hmdwNh8r8@work>
In-reply-to: <YxKY6O2hmdwNh8r8@work>
X-Source-IP: 115.124.30.130
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10458
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 impostorscore=0 priorityscore=0 lowpriorityscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0 clxscore=123
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209030059 domainage_hfrom=8542
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
 linux-hardening@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH][next] ocfs2: Replace zero-length arrays with
 DECLARE_FLEX_ARRAY() helper
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R291e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018045168;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=7; SR=0;
 TI=SMTPD_---0VOBAkhS_1662205727;
X-ServerName: out30-130.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: z32FWVJc7HDTaGQkZ8onS0kRlj8VCf5l
X-Proofpoint-ORIG-GUID: z32FWVJc7HDTaGQkZ8onS0kRlj8VCf5l
Reporting-Meta:
 AAH/QjvGuaqk5x26w3hu64SzqFAx0UgMcGLzhEtwiEqC7yG0FToXzhzV/P9nQvOO
 uv+vPR9Sb6VJLNUJ4ib6mkSkoQLS8MPEiP25cZ2aJPxSL0hBrNW+UOUJyxW4JO1y
 mMkiwWfueSTjtQZ/uMlH/Wge0pNwbMz+/MnWF5ZK8oiCh/7q/qsN71Tlahg+okaf
 y9833SJiU+NFUB+lpMV1RbgqcCuIebEX2UoodX7IJ9wOXaQAJZjMAEEpEoeXI+JT
 itqfHqokB2OwbazGBB5PScsNjerzafg1YXMVA+9c9kzpb0DNjBrMNSDesTLyiFEQ
 ypSRgzSQf5eNv6nZ6dEvezOJlT8m4oJPl8xopdbzWL0Nalp4jKunm9vEbsoz0sOh
 oe3+06S+RoORnYzzAy6pkDf8CW9U9TnonLjW5kvKg7ZK8Gf1YcffC7KyQgkm3E7y
 0lGwDZ8eGmTXhChAR2QT9r8b1iB6cxSqoUNtyXtF+5bb2agOP/rKCP4y5SXkjR/n
 hTBheF6PGKO9AMQ40PYcjOOh+nAtmeQqq+RZF39plYI=



On 9/3/22 7:59 AM, Gustavo A. R. Silva wrote:
> Zero-length arrays are deprecated and we are moving towards adopting
> C99 flexible-array members, instead. So, replace zero-length array
> declarations in a couple of structures and unions with the new
> DECLARE_FLEX_ARRAY() helper macro.
> 
> This helper allows for a flexible-array member in a union and as
> only member in a structure.
> 
> Also, this addresses multiple warnings reported when building with
> Clang-15 and -Wzero-length-array.
> 
> Lastly, this will also help memcpy (in a coming hardening update)
> execute proper bounds-checking on variable length object i_symlink
> at fs/ocfs2/namei.c:1973:
> 
> fs/ocfs2/namei.c:
> 1973                 memcpy((char *) fe->id2.i_symlink, symname, l);
> 
> Link: https://github.com/KSPP/linux/issues/21
> Link: https://github.com/KSPP/linux/issues/193
> Link: https://github.com/KSPP/linux/issues/197
> Link: https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Looks good.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
