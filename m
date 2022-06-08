Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87C3BC43334
	for <ocfs2-devel@archiver.kernel.org>; Wed,  8 Jun 2022 08:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nVAvFcskCAzPBU84JfSYasgwAD57+ShK8EWu9QgQp0s=;
 b=A5dy5yHwFDBaDFcl24v1zk97B27p4SvjWMpV1SeCjUQ60M7HvRaRi6jKPXGcqiKtl8AKu6CECsJe
   SExAQmqOaR/WJHFilH1FvbnixFUsdCIxoVgZNsS5ChRsvD9BtW3+ISh6AhaqzlBtda+nj2GoCG3f
   PgEmgsWWQcD0N5VxPyeeAo+kx3ABp/pwzjONBjV1DtkS/o/YIu/ES7/dXSksp7FxRZ7WhDX2ziEz
   s5S4jb2TpLVRJ11CvMFUBXdOf3Bprp/yg8LiE5jPqlVuTWR4Z0d87/qPCRDbXq38mQOrbAKRm7lY
   LMPLrqUDwuUBLU9ZITkVneNq+9SmBZp8CitNhw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nVAvFcskCAzPBU84JfSYasgwAD57+ShK8EWu9QgQp0s=;
 b=gBZRYe0t6AJmWXCsp8gdNiIw2i65CyKwCwfphtmtj6S/BgycOfRATHXtTN9BqW8OSPOOpqQs6XBq
   tw+JVzMfH/wYQBV6hMPbqzGodYCknD/nXP6/3gHeKlu8MsmHbBbTG9C86UxcFIhXk3RxnZHLSJ5O
   d8VRuK+Dxg32iN3/zp6N5gFs92v0Vf92Z3Qpx/dwNqETav0V6gmLtxAeXEc/M0fivfFl+TJYoACx
   WKPdeDh0wybRLBc9/JtNoqfxKcP3c+5FSrnHoegu/WUKJxFPVO+zNhhNre0dvfmBDL7azX3oxbT2
   93zdBuQzMWcKC62+10sGJ2ILsrQN+4wa4h/YKw==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD500KJ8GL75O80@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 08 Jun 2022 08:22:19 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=G4WdJHR4rUdV+xfGTH8rNFATll
 6h9Wcm2Dwl8hR0NA92iZAcMlUMq+fthpaItE/7jMYpDJ/PEVN5DQislISlxrB8/9qWLalvAyYsnuD
 iwsJdJaso586Ks1Q8kQXgtZey6Z0ln60+WlxtMSBFvzr/YfproiEFU/UwfOLlrcseqEwqSScH5Ktc
 /QiqmdbpVT+hAZ+PLajNvn/OMgQnAMelcQPcc2JSBA5lPYEeIF8hHk6ZUkukScqJxECoQ0pnPavj1
 UOyR1jVlo+1xfDeSJaFtQ38waU7bL998Q7LLOeVCevQ/PMA7GM8xCX0+/5U+lqDyqEbrJvp13qzWx
 uv4hyWtg==;
Date: Wed, 8 Jun 2022 01:21:58 -0700
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Message-id: <YqBcJooz2AHLC9VK@infradead.org>
References: <20220606204050.2625949-1-willy@infradead.org>
 <20220606204050.2625949-20-willy@infradead.org>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220606204050.2625949-20-willy@infradead.org>
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10371
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 priorityscore=90
 adultscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0 impostorscore=0
 mlxlogscore=358 bulkscore=0 spamscore=0 mlxscore=0 clxscore=128 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206080037 domainage_hfrom=8380
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 virtualization@lists.linux-foundation.org, linux-xfs@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH 19/20] fs: Remove aops->migratepage()
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
From: Christoph Hellwig via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Christoph Hellwig <hch@infradead.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-ServerName: bombadil.infradead.org
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: 17XAr70VtLA2uF4YG8FXNXeuhUaiJuro
X-Proofpoint-ORIG-GUID: 17XAr70VtLA2uF4YG8FXNXeuhUaiJuro
Reporting-Meta:
 AAGAiBEpOU5BQxleE+Hi+JsYU9ou5Ui1C/piCUbvHDjgqz710kk4eqWLEcLDXskl
 4Pj9TrxglgsFfuHIAurncgUTpaNN3SQjbe1pF2XuPXSuGKBvG/mXQ4O/MM39bOSp
 o9tbGdelRfxzHq+3okHkkbwucyydW/4KzgogQxWliMN8EddN09rgSl5vYOc5VeRt
 W0qzWcEa6tmTIYU4y8kzIMc8jihkHeMlATSFamOsv6v/YSnYR9Au7CMoItviDt7N
 hEmMKUOPNrIBxnqSRQahtmPQl3UU0ilywOAZRd5x6kJQIwEacOifTWd4M3ZwtnY9
 O0mtkCj+Fxwu4uE7Axcw3+SG7IyTor2vfVnwEQLr5eiAyOa6YH6RlmYp/XLAKT+E
 Fsa99LNLtgN/ajAfPTm4POe74I61s81yWaUVJZl1+i5ymtphO9lXfjn5+QLuX2u5
 SEnOSfFB4xcJKET1eOTYAtbOAdhsJkqEFmW4nejlbmqBEG7Z/IsIKh/TqrYD+UMA
 OcQhoRs/ptZxgOzDBReewRSVYq7c5TnOgdX/5kwZUtNZ

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
