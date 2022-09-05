Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A800AC6FA86
	for <ocfs2-devel@archiver.kernel.org>; Mon,  5 Sep 2022 07:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nVAvFcskCAzPBU84JfSYasgwAD57+ShK8EWu9QgQp0s=;
 b=g7H+DoGYdPuOm/qCownb7PmyG20hc6LocisklnF7uny35U+6de9LrkaoPjoC8BS5yrwtCZiaQRA+
   weJNxDZOLsBQ4S6A0vgTjHn/SUtIaELSxrrycoD12nnIvl5P/qohWvPlFFcRM6Cth8SI3KJCANVt
   WnNChvNyjqzYP6C8NZg5B5vldnSpsc1+YehgUf43zxqaGImfEJleBOxZhUsFeSRa4e1+bRiV+w09
   94qM/BGTa72431U4q7SmAvRW1nOVXARMmHb/BS582HhHyo9LI9cKS0uBmIXTRyRJpba7pDB4NXbW
   mkE4xH56vukd183WhJe9xn1z/p9XfmsyUvV4vA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nVAvFcskCAzPBU84JfSYasgwAD57+ShK8EWu9QgQp0s=;
 b=onKUFiAPakY58A49XcsY8HMd5K8vcM9EsKJ7b68GW3WL+jhP5qitU+5AYkwj+L5udcKWoI+/hjRy
   zCjON4tl0UVDoxQblrSoEwRl9fDB+AtPSygNKUuQJhQHrNLqi3tePyUITj/8j3BkcHkcPVr6UjOH
   f11NoMMMVebSNLXjqNBt0aD+5HzoMbtMmOz51uNM6Qeup6LHRz5bLZ9BYRrvjr399jfwOUJCRWM4
   mtrUYL2OM8SAam2IkzdtuO2yNaLnbE5Pmu3NsoYNah0t80PhKnzesRnGUCii3IW/WAPRj+U5C/aG
   kQbzKGvLmf6g/T+APG6ClsyXRkdO4HsriTmuHA==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHQ007PH7181XB0@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 05 Sep 2022 07:19:56 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=EDul8PbUZqexDSEARC+O4x5bH/
 auGB6OKk+a8Ks5sMCT/CTccPOGSrctKPikVvv7Lp3U6iueDrR27h7M7P9m/IMIggl3EHxmlMNWKaa
 OwgkzOzOA0QaQXTtahtFZQSFgGdf4jLBcItQPjfvIEv37oVygdNk2pmMfTu5CFQSUC52hkpgQpUq9
 Mr3+lNi8OjekJGJceOIkoApdmW/zdMFRMe1sFT5oydRpxXn9ETHMyexX3PZfklv4fg8uvX1hOL812
 d0SQCJkmvoRr9+1zOWpmgqgdqng4kyzejuQfqhb9nqBXaHFCu3FPfYdyFYbkIv4zjXce2aCZpcbNk
 3RDjGfxQ==;
Date: Sun, 4 Sep 2022 22:54:56 -0700
To: Zhang Yi <yi.zhang@huawei.com>
Message-id: <YxWPMCChCRj0yOAN@infradead.org>
References: <20220901133505.2510834-1-yi.zhang@huawei.com>
 <20220901133505.2510834-8-yi.zhang@huawei.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220901133505.2510834-8-yi.zhang@huawei.com>
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10460
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 clxscore=180 suspectscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=394 spamscore=0 phishscore=0 adultscore=0 priorityscore=226
 bulkscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209050028
Cc: axboe@kernel.dk, almaz.alexandrovich@paragon-software.com,
 ntfs3@lists.linux.dev, jack@suse.cz, agruenba@redhat.com, hch@infradead.org,
 chengzhihao1@huawei.com, linux-kernel@vger.kernel.org,
 reiserfs-devel@vger.kernel.org, cluster-devel@redhat.com, rpeterso@redhat.com,
 viro@zeniv.linux.org.uk, yukuai3@huawei.com, linux-fsdevel@vger.kernel.org,
 tytso@mit.edu, linux-ext4@vger.kernel.org, dushistov@mail.ru,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v2 07/14] ntfs3: replace ll_rw_block()
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
X-Proofpoint-GUID: -LReezBIwHe5Pir5Ce4uSs4zTkgfugJK
X-Proofpoint-ORIG-GUID: -LReezBIwHe5Pir5Ce4uSs4zTkgfugJK
Reporting-Meta:
 AAFtx/YdLBIlSJsHwAK6RNnqauiGw7iew8saXXUC404LZwqgugR/nM/qtEHpVTJT
 oHGB8TMuSwxrj8fa8YtR5gsQHinJh5IMqjFQPIuRZUcioBGuDYWf/gJsQ1hCT45n
 SJBMqoMZtBjitjwYE5r6X2ewViU++6gA25ugGiNcyaE05OS9IXfA+TWwJ+mE13us
 8DQD3pUaY02Td69yN3EULMrUo/Uikbac8upXlR7XEtaGz4Cy0zJmDIEw+NWp19OA
 R3DjXeqDuazpVZaWdf6Lydy3nEBn5S47IesDiaK5KygO3gTt9EHk+Pe4a2AAXQOK
 jNXT93Mi/hCY/yzNIzBvfMdZH6aQq5zXGX+0i48/O3zEpjLWyjM2UVvEaYS4d/4k
 kiYJ/TdXg1RAe4QxyWSw5GXMoCy0eGMA1U2PLDozkwirF+fS7u1A5EIyrGzjUSbw
 Mv6k25EtJYHOtbs4H1y5L2dDXKUjClTBjaRcvO4ncbZthxD+G3RFymckgHHLz2T4
 41846zPyI2UWcsGnA9kgSM+L41RDo9LcOHIhdzSFkvvo

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
