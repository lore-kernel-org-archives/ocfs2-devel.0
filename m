Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D5D8C43334
	for <ocfs2-devel@archiver.kernel.org>; Thu, 14 Jul 2022 14:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=KjYZNoNBWozz67XhRYToCrHZ/EQpzRFevcuFaTZ2ANU=;
 b=frJsca6TjQ0w98AUxyWMLojnsmaSmzqT1QP5cBMu9qrDzesXsatTuro7wz/TNMzrESl59V8kVh6N
   Ls6bQmR5vkv9wuc3sch4sZ0cU9TU+yI3ySVE5C24xOsicJ1T9zxnf/e/pKghGQeAs+WNKf0tYIvO
   8JXligIv8G1fy9v5azPWFQcARdEw4uigeBY/aEnE+n1ZLZb4rlPIoL3sM1Ukae49ABBfbvIUEKZ8
   JQAFvT/Xdp4X3d+3urQFaLSH7eKcr9gmff+o3xrPB484z64N3b/UtWA33yQSDFTdoUmAIOe25A3L
   +VAVBjx/sA/umULhzl+FtNoZ/FjCLVBT4rnO5A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=KjYZNoNBWozz67XhRYToCrHZ/EQpzRFevcuFaTZ2ANU=;
 b=mTM1NPhrKjouXIh7SQhYHlybuQ2+GFig1JRmemL+bv6Axne1kq9Q+QlQKaviY6TGmibJ67+D4tLy
   WhWCheHASDUSZaaEKU+ucYNGSjOhuyrZBPAAAV3Q/tsw0J6oD51cS21sDoN/LFDlnO5O7bCN8dx/
   sT+4+47Pi215sPBEno62OfuZFceHSfSwhVkuTbUMRVqsrlCMuzekHYeZ1DFTUTkiOaFz3tgeHIX1
   tgITqJniARPCIZMPite9i3RfnIpY5UbVKVHNlaxOJBMUZhNzGt2yJYW+DrxbZV+eZ6aCcInrmkEm
   qmVL3r8PmNcBYQ6S5AFcW4OitNiFgxBy1nl3xg==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220603 64bit (built Jun  3
 2022))
 with ESMTPS id <0RF0002YDMSB4370@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 14 Jul 2022 14:55:23 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
 t=1657810466; bh=QawvQ560xdvpwEjmvpfYqk0KReolW7mc5YwpiDi8AfQ=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To;
 b=pu/S7BHY5/kT9cNJvuSsMX2+ODL61NzBt9WeY0kH2iDG1wLIRcJqXa056UAdnT5+R
 AOBqk+iBbUVfpambcQLLwkcwq41iDUgaWVXHm0jCDFkqWSpDaoESYWo2IWefkCcFPR
 dNlco22a1oOA7NYcLgzPxYPBZPms8A98tFYGPOCk3otxcYnaC30u5O484Q6oS806vX
 nqNfS1uK+j9hjifljIYmah6A264d9whosKObzjpZTzUMGjE7Zx/aXeDSM0PApGB+9y
 avfsuVx4y3MSJ8j+JXl3SVk3a5IQDq2BOebsVOHim9lSZk09zLlA2Qei9BCtXZjSZp
 VkEYcHXptjpPA==
Date: Thu, 14 Jul 2022 10:54:21 -0400
To: Christoph Hellwig <hch@lst.de>
Message-id: <YtAuHaiK+Me08swz@mit.edu>
References: <20220713055317.1888500-1-hch@lst.de>
 <20220713055317.1888500-9-hch@lst.de>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220713055317.1888500-9-hch@lst.de>
X-Source-IP: 18.9.28.11
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10408
 signatures=596000
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 suspectscore=0 malwarescore=0 clxscore=146 impostorscore=0 phishscore=0
 priorityscore=111 mlxlogscore=933 bulkscore=0 spamscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207140064 domainage_hfrom=13566
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 linux-raid@vger.kernel.org, Song Liu <song@kernel.org>,
 Christoph =?iso-8859-1?Q?B=F6hmwalder?= <christoph.boehmwalder@linbit.com>,
 Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>,
 "Md. Haris Iqbal" <haris.iqbal@ionos.com>, linux-ext4@vger.kernel.org,
 Jack Wang <jinpu.wang@ionos.com>, ocfs2-devel@oss.oracle.com,
 drbd-dev@lists.linbit.com
Subject: Re: [Ocfs2-devel] [PATCH 8/9] ext4: only initialize mmp_bdevname	once
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
 include:et._spf.pardot.com include:sendgrid.net include:mail.zendesk.com
 include:_shortspf.launchmetrics.com include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: eETNwkMI0Q-eTL8gtYikiKq0xmuBFRG6
X-Proofpoint-ORIG-GUID: eETNwkMI0Q-eTL8gtYikiKq0xmuBFRG6
Reporting-Meta:
 AAFfF5HJMeDVpNrciDk10deVNkz0+cx7lPKxTLm/AZA96tKy5Pt3Syqiy6pKjiO7
 V4VFSu1C8+2LKiHaXHIqo5tpSggX8im0zvIiUUPN+9+cAz/4ter3JG7XQ+UXVn5I
 Y+xefGUZA5jGJMnPrBRbLnyAbsNfgPUoqp+cAjBRD4mHI19VIEXYuP4vuFuNnNWT
 LUFM4oPFH/3AjQk2IFpJ6MiYleV4N7wkQGW3FMJ/bK2zy07zo3d85oDHjBJ2lrre
 LQmtM0llUFmVFcgoJ5K8ULrshXq98Lc393U29CotFz1JI8XpWdRnbQaq10lJrt2P
 WKZEBn66CJslovkiyL1oWsdel9wNMDy6w8qElNea4KDlr9XKLrRiRrqXo6dNuYPQ
 oRJfYglBSFsZbmgM22R8nO4oYWgRS+0VjAbnt7fc9HCWMz96Sfi7lpaADohKQhQz
 o1ZwPOt+9hXw6J3PeBSPYBDrjsWr+rjoU7HzuDFwVV0fJmLO3kIDBuXU8xMKBbp0
 7/tJMyc6HCqEr9CY/07+N0un11aeL04eJiVuC/W5PtU=

On Wed, Jul 13, 2022 at 07:53:16AM +0200, Christoph Hellwig wrote:
> mmp_bdevname is currently both initialized nested inside the kthread_run
> call in ext4_multi_mount_protect and in the kmmpd thread started by it.
> 
> Lift the initiaization out of the kthread_run call in
> ext4_multi_mount_protect, move the BUILD_BUG_ON next to it and remove
> the duplicate assignment inside of kmmpd.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Theodore Ts'o <tytso@mit.edu>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
