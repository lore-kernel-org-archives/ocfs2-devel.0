Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F819C77B75
	for <ocfs2-devel@archiver.kernel.org>; Wed, 19 Apr 2023 02:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=7a2OAmZVpLsWbzvnfZ75bYKNUuxWo/MYOauxz4IKB54=;
 b=Jkki6+qSi+nHTFjagaGSkHO0Yy0KhQBjCrUPbMUL0n0C4jayVK58nKKjDIY2pUyIWYQCuC28ddhR
   L7Pe2tONDCiRSuziHIvXkUDNBu/ik4WE7MOLGSy0e1yKK+lLhaBao+0Xb/jbB8gFkN8PJJxg2Qok
   gK4Ge14cj+10l/0kBazlbTyIeXbUicaO9BuCEyKH5dUbr1w7jAL3HEtRZUNSDYpDruMyM/YxfL9f
   Kg7IyxLlAREu84xPA4bz+KJAs7XYzg+4yi+GKZlzD5hwnxo94CM8KsEn2zOCEaidWql2xY/qLM3t
   e3N5iyRuKLXPOLbiCbEFy7L8W4pZ562/QtRgew==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=7a2OAmZVpLsWbzvnfZ75bYKNUuxWo/MYOauxz4IKB54=;
 b=oycYOnJewg6/TfAoTvW12xJwSaqpMHn0DVrkXpVREF7ci9+2HvZKQQp7XIBFirFk6fn04Vjpr+Qo
   yQY6KwgEj1+ozob30pk9j2VfSPXz3IwnkhaHiNRGbiHMF76MSuz2/Xe8u7flW+T/UMT35mySd4le
   jS0aetepJWHfJxLwx8FeUUkd+bgYRHIv7KMhoZcsnt2huiOXUlO5PcsoQvvUWF55MkiEuiMSNJOG
   kO3o0Kq+t6Dhx+oLMCJIvmYGpbtovOVLzAH3E8qtcDXP+0PWcwvitoT0gZQxWjp/gIntvuoxmRHZ
   EBp4CT9xR0GHnWJbKn3Th9slgK70oknWC7fVAQ==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230331 64bit (built Mar 31
 2023))
 with ESMTPS id <0RTC00IXHAX2A860@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 19 Apr 2023 02:00:38 +0000 (GMT)
Message-id: <d1e719ea-95bf-bb96-62db-e550cefe0a80@linux.alibaba.com>
Date: Wed, 19 Apr 2023 10:00:15 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Content-language: en-US
To: Christian Brauner <brauner@kernel.org>, akpm <akpm@linux-foundation.org>
References: <20230417205631.1956027-1-arnd@kernel.org>
 <20230418-fortgehen-inkubationszeit-5d3db3f0c2b1@brauner>
 <7555eaf9-b195-5189-3928-c7292e4a0ba5@linux.alibaba.com>
 <20230418-vielmehr-nominieren-7f2adb0f6703@brauner>
In-reply-to: <20230418-vielmehr-nominieren-7f2adb0f6703@brauner>
X-Source-IP: 115.124.30.101
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10684
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=110
 adultscore=0 priorityscore=78 impostorscore=0 spamscore=0 mlxscore=0
 mlxlogscore=914 malwarescore=0 bulkscore=0 phishscore=0 lowpriorityscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304190015 domainage_hfrom=8770
Cc: Arnd Bergmann <arnd@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 ocfs2-devel <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: reduce ioctl stack usage
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R401e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018045176;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=8; SR=0;
 TI=SMTPD_---0VgSa027_1681869616;
X-ServerName: out30-101.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: sp6gQf6MFLSSPb--SBRNKBdNXYweqNQ4
X-Proofpoint-ORIG-GUID: sp6gQf6MFLSSPb--SBRNKBdNXYweqNQ4
Reporting-Meta:
 AAH+oWPPtIFlkWUAnwYVBb+Aad9lWpiVUQXcf2YECTdbDkyzvNrvzmqxQWIduYX3
 YJw+/KGC3XLbcivA7vk/EpMwTEsYbtB4a/lOruCksC4WHqKMk0CepZ4h2iULvOj/
 YctQ+f9I6Oq390msTqNZKweN2gqIti0Y4EnGl4gedTWzTpEmfe9adV79sxjxLwlS
 KY6R0bQXd8Hz79Fb51t017EVYe+K4+2zLfPJ1bZsaRSx2Uu0BG2rjSOyHkOLExtl
 MA2PGB+tLmRQMCDWHpHBuXcG2JFl5vvw9ocFQy8QVe34AChm8fyDJwFa46V6Btp6
 XhKaT1iziGicx1dz8dVxli1OaRFkoWu8FmUR/iTbwAOS74/qjfddeca542WDRzIY
 JE0JP4O9k8llkvhu2wEWKktSmWeagjvDsvcV4lIgr4xsnv5EDayMb5lOLPtkeC+k
 3nBzGZYAUh59LXb4VGseJ0y9DAgaLCV6qI9OuWFWWui5BBpQDhq1P5A15+m+2sTQ
 +c6rVUNOA3JzjFH6HoDdIkKiF5rdX3RRk8NxYKZ5H/DU



On 4/18/23 8:56 PM, Christian Brauner wrote:
> On Tue, Apr 18, 2023 at 05:37:06PM +0800, Joseph Qi wrote:
>> Andrew picked ocfs2 patches into -mm tree before.
> Yup and that's fine obviously, but this belongs to fs/ and we're aiming
> to take fs/ stuff through the dedicated fs trees going forward.

Either is fine for me.
Hi Andrew, what's your opinion?

Thanks,
Joseph

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
