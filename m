Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C292C6FA8D
	for <ocfs2-devel@archiver.kernel.org>; Mon,  5 Sep 2022 07:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nVAvFcskCAzPBU84JfSYasgwAD57+ShK8EWu9QgQp0s=;
 b=E4KEF5NEFxPyLGZQNN5zNRWHGHCawm5by0/7xyB4dKIRsu6v1W4IFysbRFxjSOdLnZFNcgezceHw
   yx24HIYiVYdaFpJ2xA7UH55X7TKUcmJZWdNcwp8e73inpm7ZpE5dB+h79aIQihLhe6E3mLBjf04m
   QY4PfYrgxB32HobQWrNDAvTNbFD2ng4gEGHmjKlBtmqz5BgmsWL8Giw1pBUCYd45RUIcQrklREsT
   9qevPuucH3EPacFRWuqioBgHOyPJNLN4HRtuaSbUE+1hLxSjkAIjalq5HD7BcSLL7pVDXP1Q2TXp
   ngKQ+2/+tIhl2Jwhwt2VF3VNHYs64SATbwprEw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nVAvFcskCAzPBU84JfSYasgwAD57+ShK8EWu9QgQp0s=;
 b=djAT7zQ0N8XZAQKcWT4E0+IqnBcyrexD3yLPMgQHguaytOxayhTYuUGsQPpIanFrSJ+HoIfnlnNQ
   3jyNinmU8hpQcrMJUCrRLxVpzgcjrAi/ODvcoPKPFDwaX1ZciN2azciqxNrW5WAz+h7U/D0oWbIU
   3YcDYj6HczNySbfSW1dpqiIGMpyOPN+BXR9oxheeKNWwsUkUG2PAjjQHaue1WrKBVlNhOAqwbS4M
   uJfkqk7i4ZnYXZkIsSAzYFK9ik76vH1CdHRM8KYbvYxPuDuJJX7yZFZmlwv0XCsIA+S4R3EeOEkd
   NPSqBXJMGLT0DMIbUGy+YyACI6pnUGPcQVQP3A==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHQ0039H712HQ60@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 05 Sep 2022 07:19:53 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=rtrlNCFpQu+oE5HQvbd8NN8bYF
 F043Oh7qVBPRQtttPRVbjuB7FhHrkI/gHK0hUupHM+5p8gCaIgYvxF581AlCz22YyrI6PhM5SLP1q
 KeJ/E92INwjEUS/10ygwNmxkjfpAK+VVz55V50dUqzY+BItd5S2pUoqJUXeTqCCWH9ra3b/KF/ifx
 7VLtq36s4Ao1ARUmeQENRm009UWJjoosM6JLpPhN9gD+ET+QjPsvBVXW0fOOzSj7JduRgyIhw/uJd
 tjuAmRlh1DRamI4HtHmqUR6NpGYN9sMygbVSfoADCzM3TfPIJLMZhRMR72+3pudT+aPYfrtjINvI+
 1qvsl/yQ==;
Date: Sun, 4 Sep 2022 22:54:39 -0700
To: Zhang Yi <yi.zhang@huawei.com>
Message-id: <YxWPH5Y31xPhMiFT@infradead.org>
References: <20220901133505.2510834-1-yi.zhang@huawei.com>
 <20220901133505.2510834-7-yi.zhang@huawei.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220901133505.2510834-7-yi.zhang@huawei.com>
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10460
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=234 impostorscore=0 mlxlogscore=394 suspectscore=0 bulkscore=0
 spamscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0 mlxscore=0
 phishscore=0 clxscore=186 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209050028
Cc: axboe@kernel.dk, almaz.alexandrovich@paragon-software.com,
 ntfs3@lists.linux.dev, jack@suse.cz, agruenba@redhat.com, hch@infradead.org,
 chengzhihao1@huawei.com, linux-kernel@vger.kernel.org,
 reiserfs-devel@vger.kernel.org, cluster-devel@redhat.com, rpeterso@redhat.com,
 viro@zeniv.linux.org.uk, yukuai3@huawei.com, linux-fsdevel@vger.kernel.org,
 tytso@mit.edu, linux-ext4@vger.kernel.org, dushistov@mail.ru,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v2 06/14] jbd2: replace ll_rw_block()
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
X-Proofpoint-ORIG-GUID: 3UshQGAGmS0TY8Ta3GRjHx4_hlfsr7Mz
X-Proofpoint-GUID: 3UshQGAGmS0TY8Ta3GRjHx4_hlfsr7Mz
Reporting-Meta:
 AAGqRbqaitLBVwc3q9LEl/DdT7xI9ckM4iKs9bngFGS49XaupGtaNeglyS0IYTRd
 0r5DOFm5fOHVUCEp/PeQgHI0ZaMCYwS+oKfaJyHAOC5rkfTUH6fXQAtcDt28uBz1
 n9yaU78ENN1Alj9R2QZk+tW3vlVO7VmG7WECR4yopJQbEEuzcu5vp7uYJrTG4Zlr
 iO0gCHxuwKLMYcf8fOYrqPRRbDoyIdVv0yuO85n68+b7530Se3L89OAEZ1Oc8WnN
 ymUHuDujjgOb1Q4WwUpyi9vKELvaWYW/jWXd7RzAxQT/1rpj+ueyPBFfz/V5+LfD
 uSHAc53sO1fO7JTUADEjeSfCdmV/aW6CtvXbTYioiO0KRL6OuC+8Tg0uUu4wnM6/
 CTYOfF4TTaaQ1gIPkRoO3CosrExN8ne+V0JxfnRUavBE6FKSUv8QqpjniMjyK3+c
 dmt7j941GMbNJKrMvSt/zxEqKP+AhhMe1SRa4oSIsqGxUIQ8NIqChJMcBVLlqRyZ
 UCJIUyzNRBORxzA4b7bItogVAaNDEytJv848yEETqNU=

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
