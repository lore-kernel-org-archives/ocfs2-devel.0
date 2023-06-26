Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5CCAEB64D7
	for <ocfs2-devel@archiver.kernel.org>; Mon, 26 Jun 2023 07:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nVAvFcskCAzPBU84JfSYasgwAD57+ShK8EWu9QgQp0s=;
 b=VdbhucWsJeUrJY0qVJlwSARitZ3PAzyYqR0+By/7W5lfCN1kUImk2PepxzO15sX2YcN1HfjNzUko
   PQ+diIMrkQtwTqfJI0MdCup/bU/jGX+yCUC28urPddCxREwJwgy/ELG6Go38PHQQ4mRd0CtzYefk
   EJjnOKcLnzaCYP++MwHnEVvo2CB391WnuAx8Sa96n/ub+6Jx9OrdMRxbxh/495TwWPBb+eUo58nk
   C0tDnNe8BUF15Fy6EGXoqA32rEJAlMR2eO5uVhm/94KP8z3fk4jZeNiSyFF+aviny/uwc0ezmbE1
   agfE7N86qthW0K8Jf6oyju4eqc52QSoZmV0D2A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nVAvFcskCAzPBU84JfSYasgwAD57+ShK8EWu9QgQp0s=;
 b=ik7DxqFI0kBdaPqPVEKOVSa30Bi4E2uh1NEKlpgmEsRDkuKWAzDvN6CYpAXanM94h3u9AYMdojgq
   /QXUvIKtPxRFlGDMZ1YV03cF/LAqOaoEdCxTWPbK83JfjC/0LwJqrm3ghipQwtpog5cXvd5rRotU
   D1y64+oDiGp4so3JhYSm6qJTxzXsZvkMPLQ2fAhsDRATj9pRpzSSsVJlaYDev4V2oje7FeQOnq4Y
   1f6jS+tN7w3gJR5bLtgGQ3KjrCWPBN/ZQKBU3MY4wlHkdmBLC76HdLizSY4Q5xOiNPwhUFwYwI7/
   aIsEJXO96iWSMO2I7w7aqj4OUrdy5wFd6wR8yg==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWU003LXOPLK140@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 26 Jun 2023 07:56:10 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=28oUjHSFcWmcy2P/nVXM2Rn9NV
 EQvw1iHh6E8pNHSj1ngK70AHxAUx4A4VaWSBv0AxASL0u9VAjSGlhzy44wFkirMzKJ8i8OLHYfIfq
 MqXdj6akZOk7J12Nq+aXl9D+1H3e1C5CRmITDg7Cuxpww/IxWtmXx0TCqVhyP1Pw9XDF6dE4rnkpn
 dY5tcbs7B5S3XKsog2ojglLgh56zCGc/5Ls9Q3of1me0PkQNSyTijKaqX+NJpCk8WQur+Z33KoD6X
 X7rK9xsqxXYiv0fl4Uo868I+mP5laI12Ubu8P1zvXPDGcDfcy5Yn2eDxVj6w62TSJwfXbDV+UKbhR
 BDD3zugg==;
Date: Mon, 26 Jun 2023 00:55:31 -0700
To: Bean Huo <beanhuo@iokpp.de>
Message-id: <ZJlEc1+jRaV0REOL@infradead.org>
References: <20230626055518.842392-1-beanhuo@iokpp.de>
 <20230626055518.842392-2-beanhuo@iokpp.de>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230626055518.842392-2-beanhuo@iokpp.de>
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10752
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 mlxlogscore=543 bulkscore=0 adultscore=0 clxscore=265 phishscore=0
 malwarescore=0 spamscore=0 lowpriorityscore=0 priorityscore=138 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306260070 domainage_hfrom=8763
Cc: brauner@kernel.org, tytso@mit.edu, linux-kernel@vger.kernel.org,
 beanhuo@micron.com, hch@infradead.org, adilger.kernel@dilger.ca,
 viro@zeniv.linux.org.uk, jack@suse.com, linux-fsdevel@vger.kernel.org,
 jack@suse.cz, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [RESEND PATCH v3 1/2] fs/buffer: clean up
	block_commit_write
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
X-Proofpoint-GUID: _-RrlHbNoMJiXwP3ZTvJvZ-vcMAo99kN
X-Proofpoint-ORIG-GUID: _-RrlHbNoMJiXwP3ZTvJvZ-vcMAo99kN
Reporting-Meta:
 AAGd8t/pVhv3639nv+gRDpAoB/QYENpHxlHfnT4SZsUu89x+fV0TbjiU1rxq8nxZ
 z54W2EHp0E1w9C4pfUcSnhCege0zDqVglJ8VmpCuLGXXK7g1/kGIS7LoSFhdyxjX
 +9R0CXN0bSrIWITuszAAO3leofxyvWuVfWTDh5Ekur7B2vQEelYrr9UNcfIwbber
 XLwYdtA3dnqa2uf8oO9g8GPHzQ9urdgNkrXnK6cnRBbc7FnILTa5THgwEket3RZC
 BuMXan+vePc4UlieGtCErSMpukmwvYYkqObD0VpB8UoOMinaO8q5KJ5CiWeqDAek
 0lNg7nCZ8JieDMOYto0wtymNTiq+E3+irqsLKwd1IZbkLJHOqw0DGMFM59egH668
 S/EjYuKXDXC2HlvjtxrmMQMPYOSBaGTlzMewOdpBn2/oUh//YEC9OXP4vUOl9Mb6
 oDIsEtJmneeuXqppITLb6c0z06X8ROEJZrjGZX8xV1mn499AOwI05p7h3hhJ0HKv
 5dII89wSJFvbXitGz153RsTjIcTwmpWIRzUg3T8pprMk

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
