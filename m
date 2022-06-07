Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33DBBC433EF
	for <ocfs2-devel@archiver.kernel.org>; Tue,  7 Jun 2022 08:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Ft02j4t3sT0Lt/eIsiMKtTU08lwf9tgYLgqQ4RWmpC4=;
 b=PNwIdP7BqDDxUTFsDeKK//aPReje1RG041fXnlWbbgprl68nvQSdfGMjvJ5ovWcvavYAIfADm71j
   v8kAr9p/Mv+gx77ELirtInyQamQgQ2bIsyORMXzkzus2Wz1bZ/Xqgr7Y+pGaXsSYX+mMe3Uy1coX
   gsCtVSWLtiBUFldgxCcG3jrAN0GNuMOrJrGXlD3UZjQWRuWf6QHbjAqfOK7miRXPoriwsBZeuiUz
   jiesatV9KOhBJDfyJSy8vU4NptBRNt3tKLOe0WgBtiJhmuW+n/2HzzQRKpFuCOoALxsHly/qdQeq
   jdT6B8rObK8FEsl6Dy5w7kl6fs3ehrrbRk2U0Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Ft02j4t3sT0Lt/eIsiMKtTU08lwf9tgYLgqQ4RWmpC4=;
 b=SI6YPFdGiBVO5LmtB06qJtzOsT0nwpcFCKLqgnPxzMnjpsZ0EhzLk6En8MsPouwNSAwyzp/1bDhZ
   JwTaMxbMqKWGOAB9OIJqvNVSfL/jwVX3AQECA1ZbkV1ojL7ubk9Bng3eSN++uKMy96T4Mg3RDG7/
   O8XnZp/DN2peBPIYf205sCru0Twp6jkEOocLLinSBIpVFjKD6vu+Mg5hkOddyBETqTtb1Ow+Jy5P
   7msM1zUJi8SSSH/NB1OdeUcDJZTW1TcoXMmZ7g5D/iCoaHpsFbcVVZs9fyBNulwJH0g7J7sBOOBp
   opnlFINdeg090CW9A4TMtl2HKGO1XsFsIXNDwA==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD30029ML0QKZ40@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 07 Jun 2022 08:02:50 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=intel.com; i=@intel.com;
 q=dns/txt; s=Intel; t=1654588951; x=1686124951;
 h=date:from:to:cc:subject:message-id:references: mime-version:in-reply-to;
 bh=mQzWEDPxMO7UmRFxluiJ1Ca9g136QsEllPnrNDFo86E=;
 b=SR+4Hrz5ngbwlIZrEdGCfYbFlEQ4XnNRDizHWJ/w2WC/HkHkjX69yhG1
 JiTKAhuXANImdYUkjteVRsl77i5j8Ttjix9i0LbmzDUlF2OIo7QXIviY2
 YWQZjr4saDxXOPH5ETAtceeLVQ++A8i9tGybZ3vkC3jFDdxwK2PecYHc3
 En9i4FCn66z/WUpQrnViQny8Dq4KQQCuxSpaWrg/vvgk3lDFy7QXGL7N+
 B9AQGSWT9lOBWEAcUd0qgY0LNFmngB1TW9Z2CcqxtyhXjdi5uWBwoUz6v
 m1V3k8M4HkhnOgc9VtxxU4PRM3Pk5lcVBx/SJZwZdWMxh/wSLUf6T69bd g==;
Date: Tue, 7 Jun 2022 16:01:02 +0800
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 linux-fsdevel@vger.kernel.org
Message-id: <202206071552.6lOdScLW-lkp@intel.com>
References: <20220606204050.2625949-5-willy@infradead.org>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220606204050.2625949-5-willy@infradead.org>
X-Source-IP: 192.55.52.120
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10370
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 phishscore=0 priorityscore=459 mlxscore=0 adultscore=0
 mlxlogscore=999 clxscore=258 spamscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206070033 domainage_hfrom=13223
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 kbuild-all@lists.01.org, linux-ntfs-dev@lists.sourceforge.net,
 llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
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
X-IronPort-AV: E=McAfee;i="6400,9594,10370"; a="275487455"
X-IronPort-AV: E=Sophos;i="5.91,283,1647327600"; d="scan'208";a="275487455"
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,283,1647327600"; d="scan'208";a="709385390"
X-ServerName: mga04.intel.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.intel.com include:_spf.google.com
 -all
X-Spam: Clean
X-Proofpoint-GUID: sSgb7-9ZCqvHfIyDoRU6HIuhM78UQCre
X-Proofpoint-ORIG-GUID: sSgb7-9ZCqvHfIyDoRU6HIuhM78UQCre
Reporting-Meta:
 AAH4fyE62NwrKhTUr7EPy/c8xqbCKoZgffoeYMszGG0ZczVI4MaqS53GGuzNkENF
 9yzBFVPMguMHutheYkiwidGoOITwTfsWWcCdVV1CXLqpOAdS/8ZCeqyzTf9e5oY/
 8H1dbMiJRvsQrFmk9lHgylWDw5F9v+oCHCKp+0T+zVd+Gmx884Ux2UyjVaFk6Ug/
 kFeRkSqGLvsnsu2ZvO3phKPw6dmyV/Y3oqiHoTH5vPMK6d4OaQDx2DOqaTT+3Do4
 4S+WUxYxNV+OOLrfo0YgWLsH0qe1uNX8CnJ0r+BpuCBjJZY8RehetzT6XIuVmEoN
 mx14nmoLpt0uWKs1pJtZIz6+ql5+bDfbv97vAtU5QblL2wkIkDkYf22VAQP0ZXo5
 W12QmwTWk3LkQHnAU5xcJ41EMKLebxGIc9ZPLhUKVxPmK+w2DLxeQopH4o2eYDbf
 NsurWxNh6gAi92cYv30KbMV5AAKyfVlf60Pa60SZ5P+KBXtuj3je+cWELRIr2QJr
 /61n8L036cxMW80clQNxRssIDNHH8llrSe1gObsyhin/

Hi "Matthew,

I love your patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[also build test WARNING on v5.19-rc1 next-20220607]
[cannot apply to jaegeuk-f2fs/dev-test trondmy-nfs/linux-next kdave/for-next xfs-linux/for-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Matthew-Wilcox-Oracle/Convert-aops-migratepage-to-aops-migrate_folio/20220607-044509
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git f2906aa863381afb0015a9eb7fefad885d4e5a56
config: s390-randconfig-c005-20220606 (https://download.01.org/0day-ci/archive/20220607/202206071552.6lOdScLW-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project b92436efcb7813fc481b30f2593a4907568d917a)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install s390 cross compiling tool for clang build
        # apt-get install binutils-s390x-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/96e64ba8b1be545885d89f44b1d8b968b22bdb4d
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Matthew-Wilcox-Oracle/Convert-aops-migratepage-to-aops-migrate_folio/20220607-044509
        git checkout 96e64ba8b1be545885d89f44b1d8b968b22bdb4d
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=s390 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> mm/migrate.c:775: warning: expecting prototype for buffer_migrate_folio_noref(). Prototype was for buffer_migrate_folio_norefs() instead


vim +775 mm/migrate.c

89cb0888ca1483 Jan Kara                2018-12-28  758  
96e64ba8b1be54 Matthew Wilcox (Oracle  2022-06-06  759) /**
96e64ba8b1be54 Matthew Wilcox (Oracle  2022-06-06  760)  * buffer_migrate_folio_noref() - Migration function for folios with buffers.
96e64ba8b1be54 Matthew Wilcox (Oracle  2022-06-06  761)  * @mapping: The address space containing @src.
96e64ba8b1be54 Matthew Wilcox (Oracle  2022-06-06  762)  * @dst: The folio to migrate to.
96e64ba8b1be54 Matthew Wilcox (Oracle  2022-06-06  763)  * @src: The folio to migrate from.
96e64ba8b1be54 Matthew Wilcox (Oracle  2022-06-06  764)  * @mode: How to migrate the folio.
96e64ba8b1be54 Matthew Wilcox (Oracle  2022-06-06  765)  *
96e64ba8b1be54 Matthew Wilcox (Oracle  2022-06-06  766)  * Like buffer_migrate_folio() except that this variant is more careful
96e64ba8b1be54 Matthew Wilcox (Oracle  2022-06-06  767)  * and checks that there are also no buffer head references. This function
96e64ba8b1be54 Matthew Wilcox (Oracle  2022-06-06  768)  * is the right one for mappings where buffer heads are directly looked
96e64ba8b1be54 Matthew Wilcox (Oracle  2022-06-06  769)  * up and referenced (such as block device mappings).
96e64ba8b1be54 Matthew Wilcox (Oracle  2022-06-06  770)  *
96e64ba8b1be54 Matthew Wilcox (Oracle  2022-06-06  771)  * Return: 0 on success or a negative errno on failure.
89cb0888ca1483 Jan Kara                2018-12-28  772   */
96e64ba8b1be54 Matthew Wilcox (Oracle  2022-06-06  773) int buffer_migrate_folio_norefs(struct address_space *mapping,
96e64ba8b1be54 Matthew Wilcox (Oracle  2022-06-06  774) 		struct folio *dst, struct folio *src, enum migrate_mode mode)
89cb0888ca1483 Jan Kara                2018-12-28 @775  {
96e64ba8b1be54 Matthew Wilcox (Oracle  2022-06-06  776) 	return __buffer_migrate_folio(mapping, dst, src, mode, true);
89cb0888ca1483 Jan Kara                2018-12-28  777  }
9361401eb7619c David Howells           2006-09-30  778  #endif
1d8b85ccf1ed53 Christoph Lameter       2006-06-23  779  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
