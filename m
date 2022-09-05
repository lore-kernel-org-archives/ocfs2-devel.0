Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2579BC6FA9B
	for <ocfs2-devel@archiver.kernel.org>; Mon,  5 Sep 2022 07:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nVAvFcskCAzPBU84JfSYasgwAD57+ShK8EWu9QgQp0s=;
 b=ieYpmUxir/h/O7tGKl4WD5npVXqe+5ur+00BQTJysDS6WyJf5jMU0vi4LT4S7VZQeBeiu7R3uAYe
   LXFh/LgibRtoPfT772qWayhQFo/l2IXF5ezbzbAB2TGeLhIO+JLcl6wj41TkDkZM5J3AA1mcdNc/
   gai6FkFrr4mkisiThh1Oe50GeTDjoL7hm4NbUzRjRUxPNqAPpSF2OFNPk4zv1aIKAmaC+p0Tj6j5
   g794JruJ5Q5eK93i9f4i0/YxCHC0KRkKIS5abjSw0/8ZU7qpTDTMmuhKIhKwNwUwqbg5ucE84nIP
   C0voIFAsZWq+nORXIXW/ZhzsVg7BFL5OJ4iIiA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nVAvFcskCAzPBU84JfSYasgwAD57+ShK8EWu9QgQp0s=;
 b=W3QvtOrxP52QDl5hLFzmyP9tQJ/NA/rcI8S4RL9QClozI4X1Ko85WPkS/m2RPfxbQtlUbrgrVb0A
   CEQABkc1HHZ+wLNOa5JjvjzfeNfVVclv4yGrKwiFf/xveO21owDyW3MeIXwMQoZPANwdNIDqJdRl
   LFTMYs0Ju59RaIFCQhIGq8cO6fA8p75MpwUd2Tw8fOFLXeoSvwe7uutrymE/qHK4MV20+mgYaAr8
   5DEBZ0DUIZAhff01YODV6yNrZ5syErbIkH+BqkMTYf5Nuqe773Y/PPqWA7tvtRYFqLc7GGjUsSSS
   dcrzN2rDsoHhXzaSGDClFtU5layQLziKJMCkhQ==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHQ00BWY710AO30@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 05 Sep 2022 07:19:48 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=vm4l425fNSSrq0X+a975fi2cLP
 iR0bAHDUwn4lYQgGhQDRMbY30/QJxoyBOh6vZtDcyLzjlAo/sft8tZ5NjdSE4fpIot16fH9TYppSD
 0oNUPTjMZ+O3kAb61EZpGrGkaZeA88lVvi8h2gBv3hBu8NTWp3wDGxc+xwon0GwZjr+6eaqPHNCTr
 Gj/yezBM8gtX7LL4zXsMqFkwCTHQTv6Oz7RtXYNPGeM64qR5Fvz62pK/AfRPG1iPIBCN0E2gnKzhs
 aj/AspoksydrExNt4z4hUYjOTFCl0mTydolyA/N4SnmEOaIIlr6j4YECIlFrmIE2ZCmcaSZMGYsV1
 ioCNYC5Q==;
Date: Sun, 4 Sep 2022 22:54:19 -0700
To: Zhang Yi <yi.zhang@huawei.com>
Message-id: <YxWPC6p3wKXgoe0q@infradead.org>
References: <20220901133505.2510834-1-yi.zhang@huawei.com>
 <20220901133505.2510834-6-yi.zhang@huawei.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220901133505.2510834-6-yi.zhang@huawei.com>
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10460
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=182
 lowpriorityscore=0 mlxlogscore=394 mlxscore=0 malwarescore=0 suspectscore=0
 impostorscore=0 bulkscore=0 spamscore=0 phishscore=0 adultscore=0
 priorityscore=220 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209050028
Cc: axboe@kernel.dk, almaz.alexandrovich@paragon-software.com,
 ntfs3@lists.linux.dev, jack@suse.cz, agruenba@redhat.com, hch@infradead.org,
 chengzhihao1@huawei.com, linux-kernel@vger.kernel.org,
 reiserfs-devel@vger.kernel.org, cluster-devel@redhat.com, rpeterso@redhat.com,
 viro@zeniv.linux.org.uk, yukuai3@huawei.com, linux-fsdevel@vger.kernel.org,
 tytso@mit.edu, linux-ext4@vger.kernel.org, dushistov@mail.ru,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v2 05/14] isofs: replace ll_rw_block()
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
X-Proofpoint-ORIG-GUID: VKZuEW96kEuIingeO7TBodhBslvzP1UY
X-Proofpoint-GUID: VKZuEW96kEuIingeO7TBodhBslvzP1UY
Reporting-Meta:
 AAGLpG3z9v4Am9wuKaiycStAYFbgNMAS7fBXv/6h7ZETNUl6737w4JhmcUCnwmoV
 bvbXvsrTCiGv5nu8kt207dQQhtJy6QzoMvELGpCG6rxaemPNsmD4gxP3lY5zD+kP
 vwE7QN+4258SygE/bRwNtwDcod/Kyj3T/alnaJI1nxjpPWRYS+U0mBTfyPx2zVc6
 He4gXXR6EBXOMIYSMKJzQ0CF+qU9lvV85gFADAMIeouvdHY0LLg4xwkbmicnuuQ6
 HEeByYamGEPD9KCgQjqJatWFNY7l0ibTMYSDS/GkGdDSMM+/E2+/Z/MejmEU5GPb
 jxVHbviDsvxJUpQZTGhc0YtlJl6fV6gJKNFPEJKzBYslE2Y/KokPJKizA+sKUoyw
 JWmXyqmjafcABh0DNuQ+gbPiX6L9dx948hjQGPWrFNGnY+mgnufO2j9+x9MLuXqs
 HhPKqsk2EmQoYYtwHx6YhqsKghoc1jsf/9xANZWyF8+PPJ9h1lGm+HPRLl0KCvqR
 Nwre+RjmtNoHt28OkHJHtz6y2l+5Dmt7cvz+d5ESjjw=

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
