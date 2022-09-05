Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B9FCECAAD5
	for <ocfs2-devel@archiver.kernel.org>; Mon,  5 Sep 2022 13:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=mVBQ/cpj+mu9cdsYCAJ35wvW8pT5If8gnLelZTxbp/k=;
 b=rlLVgXvyk4+wSadCzUsP7tP+Myg9cIbp3/dW6IfvPnw8YvY2ouM1uLKAqEZl0vp6EoxlB4C1QwCi
   aYD4/zglKVtqnFuXT2GZj+ye2cgKIwvmmJnx4YFKaAglvk0KnkZO2kpZ0/hwiiF+gGXLuHYo1uw0
   OA/fuPEz8ixgEJ0k3qpzPPbVO2M7k51eQKAMwmY3mDpzGy+Gj+b8VkCNSNtgbjWxcE4Ydx/YQ1E+
   /nsSk45j0A7jje/qJECIzr5hgfg716BtmQJzsYinZqcWvlv3aVUl6RCOml7CrVHZZrMf8mIPCjcr
   EI+fm2AQy15e2SEN2KLF5b2zugOMG81qLJJHLg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=mVBQ/cpj+mu9cdsYCAJ35wvW8pT5If8gnLelZTxbp/k=;
 b=t1YpQS3BJ2aeRcf7x9nLglgyg79ZXgo4A6G+bAsdolnADT7Smm8mnTAoC5Yx5xq/5ifFGcIbys6y
   lTE5g6Rur9F2drzYNulrTXPM0/P2V3Uin1M+aGOHg4y0BFjfha+Bmpg5tC8BZJ+y8OHPRJLU8MgU
   znRx7mQC8Nsbg/L4JHO0rADrmQzheXgjfNE/tTOHSvFqqc4MupBEk7R0ouPI/dbsR6uKyCGgWR1x
   lSpTDfVGTzCjkBtbKKas/fCmgluhSRxPo+sE3HY9m7gT3cP3o7QUzPLJi98M90ckVTY8ZaIYw4rT
   R/rLBLjyeuGFSeRU4PU9ByK8fADuhpkp2X1uNw==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHQ00AIQNLAGF10@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 05 Sep 2022 13:17:34 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
 t=1662366211; bh=Opykd4NroLOvUVAS6DC0mH5AVipCgMT0W9fOrq2cA5g=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To;
 b=kQY2cNMKCxqeSaFySEG9If6ZtQ8BhheeiKQJIw2xRYU0mwh5KEc4n5fb1xfvPk4CZ
 mBNdt31pMRPo3WHANZ5/Ldd6KIRnX21xck+7Bwn1Fcrsc5FcAOy78knWuHYTLXAl4g
 DxocwCUAw/g0qM3+vyInmt7rzH9XEt3Rw96cWfFdL1E5K22280Elx75++itsnVc6Gr
 BQtWa317FaLTf8L+CdQ4p6Ae6qIlTOrneZoG/Z4wofU62NxWKd3WMtYF7anpMD6LxL
 vXTuclZkTdheNbZQoIMugvCv3ZQ/q2LRDpdTb2u/xsaul3tZnLnf3enunBF8CgAtMV
 Liep1iIsFATVw==
Date: Mon, 5 Sep 2022 04:23:24 -0400
To: Zhang Yi <yi.zhang@huawei.com>
Message-id: <YxWx/E0TIhBMhaq6@mit.edu>
References: <20220901133505.2510834-1-yi.zhang@huawei.com>
 <20220901133505.2510834-7-yi.zhang@huawei.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220901133505.2510834-7-yi.zhang@huawei.com>
X-Source-IP: 18.9.28.11
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10460
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 priorityscore=30 suspectscore=0 impostorscore=0 mlxlogscore=728 mlxscore=0
 malwarescore=0 adultscore=0 clxscore=90 lowpriorityscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209050039 domainage_hfrom=13619
Cc: axboe@kernel.dk, almaz.alexandrovich@paragon-software.com,
 ntfs3@lists.linux.dev, jack@suse.cz, agruenba@redhat.com, hch@infradead.org,
 linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org,
 cluster-devel@redhat.com, rpeterso@redhat.com, viro@zeniv.linux.org.uk,
 yukuai3@huawei.com, linux-fsdevel@vger.kernel.org, dushistov@mail.ru,
 linux-ext4@vger.kernel.org, chengzhihao1@huawei.com, ocfs2-devel@oss.oracle.com
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
From: Theodore Ts'o via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Theodore Ts'o <tytso@mit.edu>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: outgoing-auth-1.mit.edu
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:18.7.16.0/24 ip4:18.7.21.0/24
 ip4:18.7.34.0/24 ip4:18.7.62.0/24 ip4:18.7.68.0/24 ip4:18.7.71.0/24
 ip4:18.9.1.0/24 ip4:18.9.21.0/24 ip4:18.9.25.0/24 ip4:18.9.28.0/24
 ip4:37.59.249.0/24 ip4:37.59.69.128/25 ip4:54.88.39.81 ip4:64.128.67.16
 ip4:64.128.67.20 ip4:69.25.199.0/24 ip4:72.55.140.81 ip4:74.62.122.128/25
 ip4:75.98.95.161/27 ip4:87.253.232.0/21 ip4:87.253.236.214 ip4:96.43.144.64/31
 ip4:96.43.148.64/31 ip4:52.5.134.202 ip4:128.136.37.0/24 ip4:129.41.172.95
 ip4:139.146.146.128/25 ip4:139.146.160.0/25 ip4:139.60.0.0/22
 ip4:148.105.0.0/16 ip4:165.192.56.56 ip4:165.193.101.141 ip4:165.193.101.142
 ip4:165.193.56.42 ip4:178.33.111.144 ip4:178.33.137.208/28 ip4:178.33.221.0/24
 ip4:182.50.78.64/28 ip4:184.173.153.216 ip4:185.189.236.0/22
 ip4:185.211.120.0/22 ip4:198.2.128.0/18 ip4:204.14.232.64/28
 ip4:204.14.234.64/28 ip4:205.201.128.0/20 ip4:205.217.12.155
 ip4:205.217.12.177 ip4:205.237.106.0/24 ip4:206.25.77.25 ip4:207.211.32.0/24
 ip4:207.211.46.192/26 ip4:207.211.60.0/24 ip4:207.211.61.0/24
 ip4:216.138.238.192/26 ip4:216.75.197.192/26 ip4:198.2.132.142
 ip4:198.187.196.100 ip4:198.187.196.130 include:spf.protection.outlook.com
 include:_spf.google.com include:et._spf.pardot.com include:sendgrid.net
 include:mail.zendesk.com include:_shortspf.launchmetrics.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: J_HrnDmRg6Dbp9khII8GiPW-aO8idkVK
X-Proofpoint-ORIG-GUID: J_HrnDmRg6Dbp9khII8GiPW-aO8idkVK
Reporting-Meta:
 AAHm3itCa5jQXKfaaGqKNRfy4jpAPHJxFeFXuiT5el8ryqgwaq7A45bOMfTdOmvR
 EUq+cGO4boF5taZn7cj02LWKzUf2TVM0/8yFzBeSKta8HomXzcJeOJsk/8bArJpx
 4GSabpAkKe5zIm4Pu/wG8u4WLmMA3pl/g+cLyVUfQHk6OSZM5xyBkPy4UYmDmw9S
 QzoSlSsWnRlw91d2IdZqRaFhiaB4+CFtdrn/R5NzoenzCzJj2MVFT9hQcdoul2j0
 UkoPI/eDTwWTHtXr8jpkXRicXe5oiS5yXBRrJlOB0KBOW8u7wIY3M4bnSpS9iylT
 aDPYTMmmr4d43nNe7shflqdvJ7ymgVFVUOBJNu8rH5ipCt5DOGTYaHc30E1VgbCn
 w0h5tcIXC76wT9VVVQ1ZfnYvx8AHyyUd9O1CZGzWkR08XtBbBd6vMQUPQSsw85Vh
 0ycHtc+pZVj3eJzI1rsGQk4E1pO7zCVc+H2QxYe3FD5EzrOsFX8iB2kjAfV7f4hn
 vf0Lf313hHGaZeW9ZguSqQNKydmS/ewR0QvC9Y2EGIbe

On Thu, Sep 01, 2022 at 09:34:57PM +0800, Zhang Yi wrote:
> ll_rw_block() is not safe for the sync read path because it cannot
> guarantee that submitting read IO if the buffer has been locked. We
> could get false positive EIO after wait_on_buffer() if the buffer has
> been locked by others. So stop using ll_rw_block() in
> journal_get_superblock(). We also switch to new bh_readahead_batch()
> for the buffer array readahead path.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Thanks, looks good.

Reviewed-by: Theodore Ts'o <tytso@mit.edu>


					- Ted

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
