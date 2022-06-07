Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D10D1C43334
	for <ocfs2-devel@archiver.kernel.org>; Tue,  7 Jun 2022 03:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=F2eszGqbhFuF316fLhApJ8o/ICBVjCLrXiay2q7QFDg=;
 b=Yrp8aDxD5DAYkvvek6mUFHK33b6ZygvC+mrQTepOb5kC7W7rO78gQigArG2TN5faA1a+V38GhIEO
   llrvHhlMWuNY1THzPkN5ky9UXf/HGgrMqg9SEqjLfhYZt15MsvRkRYxlqtKfvrxfwaV8Oyq+abf/
   +FkVs/SHC0omHaGCp3wQ0Jbhlyq7ZNfjcb5kvu7nY5esOiD5hFjlZWq7juwN/vgB/wkLQr29x6yg
   7sIMfdkBxBfJe5BPQ7Rkr+iI9itFNjIXelUWZdhlXNu3NyVyGkGV2QlhV0duVle8I9Xx5aHVHtsB
   J5Plur9duYhtfhxuUnG/S8KYB4o+fDNSOU/u7A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=F2eszGqbhFuF316fLhApJ8o/ICBVjCLrXiay2q7QFDg=;
 b=bnid+QqpL/d7rY/zNvufbIQiXFJqA75cODpSNeYQZ34CK3/BIjldG+5RY+6wPceQ5KjHvwybtafg
   ytbzo96UDaSw9mXJxhxNoHOu5K+M8mUO+DWGMUxFYV8s1YniQSKF3N13GHKhC1QfOPP3OuA//dt/
   dhlnorN7WlFEMJapew8u2dxGGsPZLKSs2lV3qqCifEr+ghuwat02pLriQfBhdmmMN1fdvKUvVpok
   d0eljaQ1RS2qo58J0iZZhw+BFwduJwbDm04uRXcvW2fgHPxqsgO35fotxZGMLaHZ3QJxxuAgZ0Pj
   eoEfae4jPCvytfv3D4pMFspDB8osmGunE7IEGw==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD300CB08VRLS80@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 07 Jun 2022 03:40:39 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=intel.com; i=@intel.com;
 q=dns/txt; s=Intel; t=1654573126; x=1686109126;
 h=date:from:to:cc:subject:message-id:references: mime-version:in-reply-to;
 bh=w4xeyqU+kOhDYzyqy82v69OYCHkAH6xk8Nd95qrz48A=;
 b=K5lEoRQ3cuBWGV3w88wuE4bcE2ZXqSFooSbHIB5EMB7Z5I42eLHCNa6B
 0pgWXkMMS/vU+V+vKV53le+LgeWHlNR4EQeDLCR3+OKg4sn2SKXoa0Yl0
 z0RbB+RR4tUiD2i1/pYUGs+JWwHSY8scW1ReMjx6ZY5SGUgB/3naTVoHV
 zxl9u44kHTb9IfkaCirlofFW7IQo9VztXHL8f07E4nnhyVk9RWDtlr1dL
 Vpkx6bbrBbLQR+vLN6gLt8VnzTqG6krhkQ3Axz97g+tCa2OXeKRHEwKAF
 4B0diwN2iQztWG95f+/Fj94O+d1O4KXnrbljg8UXsnkPkDo4XUxcCC38x Q==;
Date: Tue, 7 Jun 2022 11:37:45 +0800
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 linux-fsdevel@vger.kernel.org
Message-id: <202206071139.aWSx4GHH-lkp@intel.com>
References: <20220606204050.2625949-5-willy@infradead.org>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220606204050.2625949-5-willy@infradead.org>
X-Source-IP: 192.55.52.136
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10370
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=300 spamscore=0 bulkscore=0 impostorscore=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 mlxlogscore=919 adultscore=0 clxscore=223
 phishscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206070014 domainage_hfrom=13223
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 kbuild-all@lists.01.org, linux-ntfs-dev@lists.sourceforge.net,
 linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-block@vger.kernel.org, linux-mm@kvack.org,
 linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-ext4@vger.kernel.org, virtualization@lists.linux-foundation.org,
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH 04/20] mm/migrate: Convert
 buffer_migrate_page() to buffer_migrate_folio()
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
From: kernel test robot via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: kernel test robot <lkp@intel.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-IronPort-AV: E=McAfee;i="6400,9594,10370"; a="256542174"
X-IronPort-AV: E=Sophos;i="5.91,282,1647327600"; d="scan'208";a="256542174"
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,282,1647327600"; d="scan'208";a="579430786"
X-ServerName: mga12.intel.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.intel.com include:_spf.google.com
 -all
X-Spam: Clean
X-Proofpoint-GUID: HPzfT8NIfbiAi4OXj9puIwvgP_Si9Jqp
X-Proofpoint-ORIG-GUID: HPzfT8NIfbiAi4OXj9puIwvgP_Si9Jqp
Reporting-Meta:
 AAH+u7xKLtac1pTo1+4xRzF6SNc6kalEsIIs7hTUjsjiHZFWBAlmRgeQwF2bRoVR
 fx9HujYmOfULAzLERpB2qAa76W4vQ8NHf/ffpjFWqxAbtVIv5xQ/DpuNhS6NgSO4
 CPSgkpKgeyWNcS6VVgm75UcILImUGNprsIVGR1C3YwNlR8Um7+A2uG7nx/4mjGAw
 Vqf/+40rV6BZmWcRqkjKypZdmcKnL3IC2nwMIdZOSR3SW4ysfNVJSa8mVwuj90vf
 2GyiA9XuyfGoTCqI8yOmEzVhCbvak8UMZ8yQs6XyRvnZCo7VIGYPcaqTYDoaNGXL
 pbYcvNI07L4o1kRazOOpt8BtUt44YmRliWc2O8GGRPiG3xgsGPGldz0Xy8taeoMy
 TZ+9rvPUc9EGW7upxgKGzMxlRcgv/sl4gHNMxGftvsawjqx93rMqL1ntNpLY1jED
 2NOGw2+Lqj3LUd4IscXlwRPW7RnTMowPBfdMNUnTrPIryqfMYDlq4XcjDbtITjsX
 SD9tQFnEWbijbyzDgK4VcPCga34EKIIhRs8hegrHpjY=

Hi "Matthew,

I love your patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[also build test WARNING on v5.19-rc1 next-20220606]
[cannot apply to jaegeuk-f2fs/dev-test trondmy-nfs/linux-next kdave/for-next xfs-linux/for-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Matthew-Wilcox-Oracle/Convert-aops-migratepage-to-aops-migrate_folio/20220607-044509
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git f2906aa863381afb0015a9eb7fefad885d4e5a56
config: i386-defconfig (https://download.01.org/0day-ci/archive/20220607/202206071139.aWSx4GHH-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-1) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/96e64ba8b1be545885d89f44b1d8b968b22bdb4d
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Matthew-Wilcox-Oracle/Convert-aops-migratepage-to-aops-migrate_folio/20220607-044509
        git checkout 96e64ba8b1be545885d89f44b1d8b968b22bdb4d
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> mm/migrate.c:775: warning: expecting prototype for buffer_migrate_folio_noref(). Prototype was for buffer_migrate_folio_norefs() instead


vim +775 mm/migrate.c

89cb0888ca1483a Jan Kara                2018-12-28  758  
96e64ba8b1be545 Matthew Wilcox (Oracle  2022-06-06  759) /**
96e64ba8b1be545 Matthew Wilcox (Oracle  2022-06-06  760)  * buffer_migrate_folio_noref() - Migration function for folios with buffers.
96e64ba8b1be545 Matthew Wilcox (Oracle  2022-06-06  761)  * @mapping: The address space containing @src.
96e64ba8b1be545 Matthew Wilcox (Oracle  2022-06-06  762)  * @dst: The folio to migrate to.
96e64ba8b1be545 Matthew Wilcox (Oracle  2022-06-06  763)  * @src: The folio to migrate from.
96e64ba8b1be545 Matthew Wilcox (Oracle  2022-06-06  764)  * @mode: How to migrate the folio.
96e64ba8b1be545 Matthew Wilcox (Oracle  2022-06-06  765)  *
96e64ba8b1be545 Matthew Wilcox (Oracle  2022-06-06  766)  * Like buffer_migrate_folio() except that this variant is more careful
96e64ba8b1be545 Matthew Wilcox (Oracle  2022-06-06  767)  * and checks that there are also no buffer head references. This function
96e64ba8b1be545 Matthew Wilcox (Oracle  2022-06-06  768)  * is the right one for mappings where buffer heads are directly looked
96e64ba8b1be545 Matthew Wilcox (Oracle  2022-06-06  769)  * up and referenced (such as block device mappings).
96e64ba8b1be545 Matthew Wilcox (Oracle  2022-06-06  770)  *
96e64ba8b1be545 Matthew Wilcox (Oracle  2022-06-06  771)  * Return: 0 on success or a negative errno on failure.
89cb0888ca1483a Jan Kara                2018-12-28  772   */
96e64ba8b1be545 Matthew Wilcox (Oracle  2022-06-06  773) int buffer_migrate_folio_norefs(struct address_space *mapping,
96e64ba8b1be545 Matthew Wilcox (Oracle  2022-06-06  774) 		struct folio *dst, struct folio *src, enum migrate_mode mode)
89cb0888ca1483a Jan Kara                2018-12-28 @775  {
96e64ba8b1be545 Matthew Wilcox (Oracle  2022-06-06  776) 	return __buffer_migrate_folio(mapping, dst, src, mode, true);
89cb0888ca1483a Jan Kara                2018-12-28  777  }
9361401eb7619c0 David Howells           2006-09-30  778  #endif
1d8b85ccf1ed53a Christoph Lameter       2006-06-23  779  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
