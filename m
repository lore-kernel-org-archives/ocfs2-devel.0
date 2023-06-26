Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0F54EB64D7
	for <ocfs2-devel@archiver.kernel.org>; Mon, 26 Jun 2023 07:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nVAvFcskCAzPBU84JfSYasgwAD57+ShK8EWu9QgQp0s=;
 b=RxFkjsuU8OobgipEnT69fSPTPKmjhDbtNGn4kLFxplgbzR3MaDEysZg1iO0Q7qa05KI5mdFbzBip
   fm2dqKut0krJ6mtw7HAhiDJKwe9vxlyFfsMxlptqAiSgmYIIl2YJkgZtre5ZM+6EYd01KzS6lMVn
   j9+2fR0NsV+9vBnAweyJx47VuduOiSVK3aQpLlVZQvmhYrRIimPM7vU/yiBSgI1N4Z2STMX25xIQ
   1uXz2c8dJOfAThoiEocoZPHmPMiV/CySFQbCvYdlAsJ042nVM/NAuT5hz6sMYWO+8jdgqdgCEI7D
   sOLfTUUGtJDiCv9d+44omCaMGHXXKNzgnencqQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nVAvFcskCAzPBU84JfSYasgwAD57+ShK8EWu9QgQp0s=;
 b=PsH5qT9MZgW+2QMH5ZiBZwwrcDUZsZoxOIVEvwRws5TdWT+DROXz/1xufcaiMJeSeZOjXm3IKyQ7
   N7o126CdiRzkHNX8dmECEJgRnDeVhJeLYk7VSedRPr10OWBiv1RwnkFg/ayvwZlth3YlEC7455q5
   l9MnbIqI4whTkHWAgpsSpm7GbTdgrBh37kAmRQFXQF41za00zgbdi1Lec23V7kas7uqn2hHGL86A
   IV30ub4UKAYpOa4I3cBrEvl+1Pk/v1r9BU7lFl3bHOsLvlapnnXFi/LoPXSduhHAgew04G2Tbnsv
   TmqlYDsAMdfkz6VSmMehZPXL2JjK3hHnSMnXeg==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWU003WPOPXL690@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 26 Jun 2023 07:56:21 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=koVawv21+4nk5EmTbsanG4scAf
 ZitGqUvhvb1pqnPUhBu8dq18h3NwC/QTNsIILUylVoEZCpMnZtvi1lb+uVfA1T6WIwkc6Gg1JAz/e
 mfetdA1UmIoPkuTvY3Pf9m8xgyCC/v1Wtt9grLUvTSVhnFB94EITb2VhmuQIwbACiW2XYQJQvVb44
 axh4/1XFEP/blscM5RSV62nkUxG0UkKipGI3oezFI/uZUMVCca7frZ0UEN3AKB6mOXss8OFgFAymn
 JArOJ92nkFhJIEIkoH6UStLcAan3QGemr4oMhZOaIIK+qxoAdMtOfzingDwxJUwRDQg3srsRb20NF
 KiJxWXBg==;
Date: Mon, 26 Jun 2023 00:55:56 -0700
To: Bean Huo <beanhuo@iokpp.de>
Message-id: <ZJlEjEFzWb+P1ygx@infradead.org>
References: <20230626055518.842392-1-beanhuo@iokpp.de>
 <20230626055518.842392-3-beanhuo@iokpp.de>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230626055518.842392-3-beanhuo@iokpp.de>
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10752
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=138 lowpriorityscore=0 clxscore=216 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 adultscore=0 mlxlogscore=605 phishscore=0
 mlxscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306260070 domainage_hfrom=8763
Cc: brauner@kernel.org, tytso@mit.edu, linux-kernel@vger.kernel.org,
 beanhuo@micron.com, hch@infradead.org, adilger.kernel@dilger.ca,
 viro@zeniv.linux.org.uk, jack@suse.com, linux-fsdevel@vger.kernel.org,
 jack@suse.cz, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [RESEND PATCH v3 2/2] fs: convert block_commit_write
 to return void
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
X-Proofpoint-GUID: tkszgLfv_eeWZA6ODZUxAqgGTn4S-rxd
X-Proofpoint-ORIG-GUID: tkszgLfv_eeWZA6ODZUxAqgGTn4S-rxd
Reporting-Meta:
 AAFZal5GOeckqfmMUS1j/Xzagh9UeWYR4HCKkn0DBrUCwy4mquKYilHtnLuRzI5m
 /iueKyD27S8HP0focNqvJK9To+LH6GdvpnlfT2YRxnByLOjCIh/UEf0xRsIdAJV7
 MmA2tbf/EOyLKyUpOvRaPOsic4IdqmbbZaQCVAQK6Uxue4KfUD7uIfxINFxBQl3i
 xU44Y6UBDAytZHU96h5K092f7fGRSM2nkhnhAWuN17U0fG8QXqF29WF3hPeSvK4X
 40lu66Bd7uzeV67d64WfEbk3QTav+55ssyT/ZVuP43WBPkQg4pq2YLQ2TPn26YOA
 XgVNfdztpEX1sdjMN5/gBN9GD5hbVfrnoZgjvfU2ypU71h2F5QZRdpceqIVfq/Mr
 Mg534HAFvy6ZwCzfQMYMwt7aWb2FN1csx/Zssg3dTWG+Yg/wki9qI44WHgC2Tpnw
 9FSJUkQFAyUA2jzHkGIXney5BeLx/+TyF3gl0G3ORk8bW79cmAqYjwMCm1oLdB9t
 XhEweSLgMKeZM9QA56zYPdqjZXFN8hb42rt85EyM6gUW

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
