Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA52DC433EF
	for <ocfs2-devel@archiver.kernel.org>; Fri, 10 Jun 2022 02:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ksENhRDRHE0ajVLj2PB9jjUg1jckh93uC1GSe6KfFKk=;
 b=tMmkXFJF78LBPG4wQs6fKMmg7ycofQGLdcMksk/c6zegN11aFYNmh6WeYoHIGCzgbfF6Q2mcRlsS
   7kWRbH5WE6PtzvifIGH9MKVdJ31SwQ4UUdzSIvz1kCIv2mJEu+WE4qmR3wsOHN/e8qJaZgoowsCu
   vqESU2x3OiLDYh+sEmB7C31N1X9YmNx8HzORQpIojlFA+5JHP5ZnXMbbJMSyT5H3tC/HyI2vaxWZ
   p87Sbw7wN8y1yJvOhwNPfb6Yg2ClwfZumOGMrHt7mFHsVBYZgz0Z8RuQHdvDZA898g+/PS+dOgf0
   HtblbhhG8pne4GHarCtTbqL2vmdklCWN8GLUWQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ksENhRDRHE0ajVLj2PB9jjUg1jckh93uC1GSe6KfFKk=;
 b=bwuSfbk3Uqa9XNMs8CXAi2A0B7DJFxFClOStDjs9AMP572Udwtj4iPx5AC1MswJabb4bgA04G7yv
   hyUOnzbEGe3KIinzaxjfFupUnCiogtQsRKKgcBjEyFQGa8vhuQK9ZXm5nCpcEZcXabFMp6on5WNE
   6+yrbxudEUvntoehPW4UO1+mtopxOYCnbL1QoI5CgnZmeTo/CBvIU9iQR/72t9wxOu+syMuKlMPx
   Vt6QrGvg0nhw3as8DTuafbpAGvzCylO6u74mR8hgLmnAs6NCsIhLOL+Ti7d/PqFzWBm6NF8Stba7
   M0dPu2581v2DJc4xK0+qnl0SCtzJzh1nWgtEtQ==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD800NFFP3UT920@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 10 Jun 2022 02:19:06 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=message-id:date:mime-version:user-agent:subject:content-language:to
 :references:from:in-reply-to:content-transfer-encoding;
 bh=45w5kBhGKqiZCRPRmIKibR7PIzMTZ0MhRrpvN+BADAo=;
 b=cu1GB5un71AeFUFZPx13IpbWePVbmTiIRsruz+Gk6YjkEmNldAobWuJ+ZKCXx5CjiF
 LYAk/YH6q/CH/zROGDGCpCeSFVpVmj5o+nvASami7rI3Kcs+Gowqd9RsXAGeByGtUfHv
 t8p/Ye+ggyK27SqgZ6u+mZfRfvjndv+vUgZQ4YG48YOHR2sIXuekRDwHNHPm1bUPTviV
 Yfabef5Ucu30y/F+QsixtXakn72Amunf8HQR4mjIx2ZBj0QZ7pG7DT+C+1KiI+WOUwIJ
 JZZ7ld6nMo7I4AToW+i8c0+4U2W1PlhAtS1xu6KveImq76KI+h8kKcnLqNPPCe5LN6Vg ls3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:references:from:in-reply-to :content-transfer-encoding;
 bh=45w5kBhGKqiZCRPRmIKibR7PIzMTZ0MhRrpvN+BADAo=;
 b=vp8cC41vUrcMyxJVG1ndz1tWC84m95WRY5/IgwJhPAIvoPmyzqoocvgcv6JwlJ3PV3
 Dem1xlWOEC2AhW5wzQeeRcUBDhasxdiAaHqPgFz18w3jKYsao38HbR7x9f8nn9aozaWj
 +sPXTA3lW1SKLEGxLkGumCPXMhLWe/hsOO5dwoVDB78FRojkQC18XJ+Zn2NZxBnTR/zn
 AzAgeArvHjloSrTglsejyo3ihso8cwZN/it92r8WTeLcqsFJgogHJoA+9ARJPdn/+wxl
 cKdiDxM3mWI9TQ9pQYSjGnGUOziFMvSswFnnr2qIf4cRKT6plaAXkvfINOAuYcqP/dZU QfXA==
X-Gm-Message-State: AOAM530VtR17GXSwCcoUeCKb90XJBN3mKMkqK0pQqgfUsKIsCQqlLolg
 r38syjzypGDWXe8Cq80n9MPj5Q5SnW8=
X-Received: by 2002:a63:1a45:0:b0:401:b128:c098 with SMTP id
 a5-20020a631a45000000b00401b128c098mr2979064pgm.263.1654827535089; Thu,
 09 Jun 2022 19:18:55 -0700 (PDT)
Message-id: <8279475c-c1e9-5222-077a-17acd56b5e6b@gmail.com>
Date: Fri, 10 Jun 2022 10:18:51 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Content-language: en-US
To: "Lentes, Bernd" <bernd.lentes@helmholtz-muenchen.de>,
 ocfs2-devel ML <ocfs2-devel@oss.oracle.com>
References:
 <1021341868.90919485.1654802312953.JavaMail.zimbra@helmholtz-muenchen.de>
In-reply-to:
 <1021341868.90919485.1654802312953.JavaMail.zimbra@helmholtz-muenchen.de>
X-Source-IP: 209.85.210.174
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10373
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=342 mlxscore=0 phishscore=0 suspectscore=0 impostorscore=0
 bulkscore=0 spamscore=0 clxscore=80 mlxlogscore=999 adultscore=0
 malwarescore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2204290000 definitions=main-2206100007
 domainage_hfrom=9798
Subject: Re: [Ocfs2-devel] how to restore a reflink ?
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
Reply-to: Joseph Qi <jiangqi903@gmail.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Google-Smtp-Source:
 ABdhPJwfbilIJId6xT3O/5GkURHkSkuXucl915YjLK/ywhNXKdoR7cHCX9juY+QiW/VBeu1s7t9Wlw==
X-ServerName: mail-pf1-f174.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 redirect=_spf.google.com
X-Spam: Clean
X-Proofpoint-GUID: sr2dZJXXbX9ySAnZ8ek3D8A3hpUXjsmC
X-Proofpoint-ORIG-GUID: sr2dZJXXbX9ySAnZ8ek3D8A3hpUXjsmC
Reporting-Meta:
 AAErXJ3/8Xwz+anJkSWRxNWVIUOUzv4+KAEb8ACu98O304rnzT4dVGTdn0Yc2LvS
 R73qyOtV1KZ0OCLu9F4iffQ6cUAA8XHr4h/j20BLScg4J9Slug9aZtmetbHaYDie
 JAhXVnOvKy42YwqIP+0KV77vdue93Tc5NHO9OasX8mRxnc2O2q4A8TlsJgOYz2t1
 fo7QqLNEJRFGJqo3BCSskwPkzf9z26uta0qvlJS90Aqp9cdv3TZGuvzX0Ct7o4kY
 E1QLtEeaSyzx4owID22TdJZah/Fp6fSNGDOULj1q9TAPNVt7BvI8f1MfSI1ook/g
 vK+/wr8yNW05YQJNO18BNIalAQe21vUTTFOxQH2omPsXX+H1N8YvmPv5cSCb0q9V
 hwOwG1dHqk9CFQZ/vvgbua2E32IfAbCBtuquWSAnIZfWNbyDRYMgk1lI4nuqEZzl
 jiRLiKfTBMjQn5HBqDaBDLR/Rw2OIcCMoFtn1rN2hhe+yFVMZht8ByKidaVsKoqK
 to5GebEcKZZybcn9PxkLH9NoejBwkTjw/AeoGYjn8d4=



On 6/10/22 3:18 AM, Lentes, Bernd via Ocfs2-devel wrote:
> Hi,
> 
> i have some Virtual machines running on an OCFS2 volume. 
> That means that their disk images reside on an OCFS2 volume.
> I needed to change something inside one vm and created a relink of it before.
> What i wanted to change went wrong. I need the reflink.
> 
> I have vm.raw and vm_before_configure.raw.
> vm_before_configure.raw is my reflink.

As the name hints, it seems vm_before_configure.raw is the source image
(good), while vm.raw is the dest reflink image (bad)?

If it is, discard the existing reflink vm.raw (better backup first), and
redo a new reflink vm.raw from vm_before_configure.raw will save much
time since your image is very big.

Thanks,
Joseph

> The files are quite big: 280 GB.
> 
> My planned procedure is:
> Stop Virtual machine.
> Copy vm_before_configure.raw somewhere else to vm_before_configure.raw.bak.
> Delete or rename vm.raw
> Rename vm_before_config.raw.bak to vm.raw
> Start the VM again.
> Hopefully be happy.
> 
> Is that ok ?
> 
> Bernd

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
