Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D38B3ECAAA1
	for <ocfs2-devel@archiver.kernel.org>; Mon,  5 Sep 2022 07:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nVAvFcskCAzPBU84JfSYasgwAD57+ShK8EWu9QgQp0s=;
 b=r0WA7tLxd6RPbraPVzM+RylVj42RnyBak9O5qpBZYBjJkdLMeWCvX5oFjil6u7eS7c+VW5fHRAJ7
   hSytvZL2zc5DzNsglzmCFj2+HXoa0UxBpKNDrrTM6Q5+d8VNr3dNJgYuMmQz1G7UXvnZAKa3UiPr
   bPq5O4bg5E4UbiWUs6ftXDccRz8pPRA1ekbVbzvmgF1LD8UMpax+Rofzle4TyDs5IMyjbR1atfCK
   k4AHV06FS3v1okZifFP5A/rLzugPuO1Z2r88LeS/Cr2F7vc1nhc8dl+MKIpO1i+qrVTYHg+UMdIM
   C0Oo+ig1gUx5ddr8tWbQaLwwobIuC9gtDo4nGw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nVAvFcskCAzPBU84JfSYasgwAD57+ShK8EWu9QgQp0s=;
 b=ldi02uYtHPhPwIXQn1gJ4YvB6Y/3hPU68JhDBhDhCkL95xoMmqOj6tG5zXeFT4lH5HZENjTCir6c
   IDsGKypnQ3QFT2506bWw+wkpNv1hJY8M4iJ2Pmd/A+j1uccfap6U/XLR2/BFj2Xmq3VMaVSC+9F9
   DiAextdCb6famsuCV7mOx6WyU8tgmWZO8PaqE6BB7SueRFkJYA5GkNe9eoIhHGYb/JkX7yWRDudI
   d6J9WnaD90nrhZ8R4lDYsX4XeMIlHcXjKl4g1ni2i13bPHbsNb3QTLUTarFBINwzOS1HNwOfnFmr
   r8xWmHZO3N1O89+7L6+YLEZEPztP1J3bpDbtwQ==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHQ00GPR70X5600@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 05 Sep 2022 07:19:45 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=X/u6oLsHGFJsJUZZfK1crt/jUm
 MNbQH+NB5706rMuJrz4yoEwmzs2NSOWvyL6C+GJdWAvm+YXWrQNZXmZPySl+rMLb/Sttiqg9hWAJM
 3Lj/zAGA5jnzNPNK2Prp6Gfs62efH+fPF7YKkPdWqQRmE1zQyjKxoexIbh/qYoII1yDbvKSvYixjn
 /DbwVI8PzD4N6WYjdW//Qp1X/uThM1Uz3TtwM8qF9MmKksTcY96g77kRoBKlgOFqdD/4mSLCNbbtG
 zr1PYx0h6p1fixs90ZNp/omnZvgrr6ivG95/9yg5XCu2VFO7tLzBfSquPaoN0V0E2iwo6m0Ym1wdq
 jCt3WeDg==;
Date: Sun, 4 Sep 2022 22:52:53 -0700
To: Zhang Yi <yi.zhang@huawei.com>
Message-id: <YxWOterPFn2YqzEy@infradead.org>
References: <20220901133505.2510834-1-yi.zhang@huawei.com>
 <20220901133505.2510834-3-yi.zhang@huawei.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220901133505.2510834-3-yi.zhang@huawei.com>
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10460
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=171
 bulkscore=0 priorityscore=300 lowpriorityscore=0 phishscore=0 impostorscore=0
 mlxscore=0 spamscore=0 suspectscore=0 malwarescore=0 mlxlogscore=408
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209050028
Cc: axboe@kernel.dk, almaz.alexandrovich@paragon-software.com,
 ntfs3@lists.linux.dev, jack@suse.cz, agruenba@redhat.com, hch@infradead.org,
 chengzhihao1@huawei.com, linux-kernel@vger.kernel.org,
 reiserfs-devel@vger.kernel.org, cluster-devel@redhat.com, rpeterso@redhat.com,
 viro@zeniv.linux.org.uk, yukuai3@huawei.com, linux-fsdevel@vger.kernel.org,
 tytso@mit.edu, linux-ext4@vger.kernel.org, dushistov@mail.ru,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v2 02/14] fs/buffer: add some new buffer	read
 helpers
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
X-Proofpoint-ORIG-GUID: 3kGLYtAcjGmmq9M12REbX_Y6A_2WDl7T
X-Proofpoint-GUID: 3kGLYtAcjGmmq9M12REbX_Y6A_2WDl7T
Reporting-Meta:
 AAE5Z0d0TEcRoVt7nyW92wq3hHD/rEdLldUyCje7moRq1AYykC5+qqgnReT4FAoW
 j6l9Xwhqj70gckxuCtzQbnje4HGEiARInDoNNbG2DwFLLEbZP1XZPpY2ncCxCkey
 3f7EEz7ilulunkUWPbYG02p1vpb2afy2i+vl10kdVHMW6v9P/vrBNU8PNX++7h7D
 doSRPMx2l9Jd3wevB55VqrWqxhI2qjGB0rT9k2269wdz9l1NW2YHCJQwjjMGpWw0
 sEj611YRrFOEUwJTiSc776GdymoT7o01R3yKxWIFLpLJBD+H+SLAip0ysspg6FX3
 J0VEkbeUZWrCFCaL0DGMK15gdIZM8klV+haba67jcjm6mDfIgF12dOeiWiXcYWqY
 YKnBPVx/T+BG8VWiI8x8yuPolLtpbDOtmqaeFR502HOkTGWYUsQpIskSWNlqta5y
 oJkY++ILyWcGhQrjQl7+QNncXbmyRuXzQRNyWhZGpMv27U0irAfcSBuPJEwQyqQW
 C+vmigJ6hDBIWXysMGwAS4F5KUHOzYATq8gRV9/kX1M=

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
