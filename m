Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DF7CECAAD3
	for <ocfs2-devel@archiver.kernel.org>; Fri,  2 Sep 2022 01:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=y9HfHjPuMGj4ogADCYM9h33QHiQ2xoC0Q/dkyyh3jcg=;
 b=QWuDQ02sASp0eL5X85RHUWodWNEJNV+bkWweTFwTe+Bme8k1L/A840I6JfrE2ZUxBeZr5zb4HeKY
   20V7zDJG7D+ZnNWo1t5eDuKnA8/Cbc0K5Mm1ql5xQpxthTPPKgMXn+Gtir1bKSFEMu4FCerhzxCk
   h2nqadcoN4xeIHP8BG/dszDH61Vi6Slg6EZrM6v6uJ4wDN0YKYSPXmXkEEWWTfqBmGZ7yXnRArVB
   Tof9bemQhwC8coD84eb9J1N420F038f5sK2YTNAH/b4h+Gjh9bfpbahMX9rKBadHsS+g2blft3v0
   joRP98Ws882Mbx56VUGnYc18+DbjsOx1i72hhw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=y9HfHjPuMGj4ogADCYM9h33QHiQ2xoC0Q/dkyyh3jcg=;
 b=r6wk3KRaBJSR3QwxEHE1htleUBfkG+PkWoShOspRSc2CkbVMt0SrqiazWz6MjcZum5+XOc2v5xpx
   QCKk08+qdgzEc/e06nC0Daa1gNctyPJ2+zpCOWeLAzkuaEzGKu2eJPhqMJBOLg50Rlp2xWy7fvUC
   VUBTuHOCU/KXjrtdL1CkB9xOc9hUUet9C7IxBcDFBfsTBCz9RGLWnjNMgXrHux4iIZ/6YpBlQMjT
   yavNwqVLXmnuwiYk+7YN67EW/Xq6v+1tHCJl1HIvR9N4dH+/cWg1Uc4zSBgl0jU5qUP3xt5ySZW6
   PuGSTZekmeruYdW7blmWx7nWKNnZFC0SN7WelQ==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHK00A5Q7U05U50@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 02 Sep 2022 01:51:36 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
 MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=AHoA94Hk0V1+0HXqlkIbJPhRwQPwm6frNDZtWCI6wa4=; b=dmkbGZng4M+5yesbaSJIyzSR+G
 SgZbfUxTIzQOoqEgJOgYQyTbTpEmNrepfK0p5bbL7T3+4dyC50bL7mdWHuenxQfkVNiuGPWVVgzD2
 XiZGRxWe+23+Lxq5+KmtXd4dgeBuM1yxgWyq6E9DpGv9YZUQ/MHtTjgPPa3VGECxozbv0Yh9vGvdi
 nFlmbUF1s73SuRIdGPhXlm208Z9Cj5Dyr72/rJaSqPIpigLDmmLr4BLYqMUs9z0zuEkaMgGDWdpCU
 SSgWvJy5sf2CjXO7IboSmtjpMkxEVrW04qP5174UeR94zvkXLDnpEdQRk/8wjIVAcrnQFbHS2l8/B
 Y3uRWgqg==;
Date: Fri, 2 Sep 2022 02:51:07 +0100
To: Zhang Yi <yi.zhang@huawei.com>
Message-id: <YxFhi1iJ2cFfKi04@ZenIV>
References: <20220901133505.2510834-1-yi.zhang@huawei.com>
 <20220901133505.2510834-14-yi.zhang@huawei.com> <YxFOqimAyJNxuPM9@ZenIV>
 <3fdab5fd-1efa-9668-da5c-889e9bfa1524@huawei.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <3fdab5fd-1efa-9668-da5c-889e9bfa1524@huawei.com>
X-Source-IP: 62.89.141.173
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10457
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 bulkscore=0 lowpriorityscore=0 mlxlogscore=724 spamscore=0 adultscore=0
 priorityscore=285 suspectscore=0 clxscore=152 phishscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209020007
Cc: axboe@kernel.dk, almaz.alexandrovich@paragon-software.com,
 ntfs3@lists.linux.dev, jack@suse.cz, agruenba@redhat.com, hch@infradead.org,
 chengzhihao1@huawei.com, linux-kernel@vger.kernel.org,
 reiserfs-devel@vger.kernel.org, cluster-devel@redhat.com, rpeterso@redhat.com,
 yukuai3@huawei.com, linux-fsdevel@vger.kernel.org, tytso@mit.edu,
 linux-ext4@vger.kernel.org, dushistov@mail.ru, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v2 13/14] ext2: replace bh_submit_read()
 helper with bh_read_locked()
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
From: Al Viro via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Al Viro <viro@zeniv.linux.org.uk>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: zeniv.linux.org.uk
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: 3TOR0r0B9OO1PXt8-qmdszliyURKwcr8
X-Proofpoint-ORIG-GUID: 3TOR0r0B9OO1PXt8-qmdszliyURKwcr8
Reporting-Meta:
 AAHaApIwPmjWY8PTsMNvFpIVRvvjAO2LgGOfKRq68UFuepgODX1S+8WqL2Bu1bIs
 AAOeqMOE0fTMgthuY54WhStd+qZgDivyoVq3L/60Q4Cyc5MgwqrnxBFBtr2AHsTy
 FuYWyKK6y2gWfeq8yjyH8MzhCpPXzdVvNU8HO1EgrvVMb1+6pz+ejkfFpEmA64/B
 cxm++K1Cr2SZMyNsTBJAL/WwvMF4FpTFg4qGEnuPgoszDccpO8iGaJbc+0S7yAQQ
 GTPpThdP18SV4lqAn+hMXu+lpbNQIRJhhJHG3WzQvHcRmGiX85DDoOS9fdXVMjJT
 LY1PYfA9tTLTceVWt0wNZUgSzPPEsPAUyuRikZPgW8YPAltVR3+selCVpC66CY3o
 Iswx+yBzkx2ZXYDon7wF5oGEYQL4fTYH4cOr3mf4b1iDNg8pom6WMuMwYL8dD/5S
 3qoR6b5lC10/0J0IjqD/s/B6fzlbWnyI35WNuqWMZsbaQXesKRXatT42+d0IsaZt
 8bC4iZ5a03crEQyw8qh/4/hdV7vERisTFQ4fvNjZVVhn

On Fri, Sep 02, 2022 at 09:32:53AM +0800, Zhang Yi wrote:
> On 2022/9/2 8:30, Al Viro wrote:
> > On Thu, Sep 01, 2022 at 09:35:04PM +0800, Zhang Yi wrote:
> >> bh_submit_read() and the uptodate check logic in bh_uptodate_or_lock()
> >> has been integrated in bh_read() helper, so switch to use it directly.
> > 
> > s/bh_read_locked/bh_read/ in the summary?
> > 
> 
> Sorry, I don't get your question, I have already replace bh_read_locked()
> with bh_read() in the commit message, there is no bh_read_locked in the whole
> patch. Am I missing something?

Take a look at the subject ;-)

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
