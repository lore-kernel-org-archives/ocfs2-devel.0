Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0972FCCA47C
	for <ocfs2-devel@archiver.kernel.org>; Tue,  7 Jun 2022 06:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=xrQUKwgb6ECTPjlBlSEf22t1XBCaqscdT/5AgJfTQIo=;
 b=dp8YsWXQnBrM33ANeX3cwNndsxg/RAS0ayh62n+uCHQNus6M2tQvheahAhEiawJweQ/BMMEeJkE+
   tvgTWC2Jl+BkmGGy2shgZqaYn1I/JSZd8arxax5IS1Xsk9sKtbZdV1WjEJH6uqPX09pQV738Y419
   G+aEYYvrlcrFxlRh/oDhA07MTlIHYIIC8Hm8hbXplXuE4URPNocFLJq00WhzBsRoTLM0cWV/NVap
   SeRx7xfTHJyQltnzCacHGKhzVyZ466oQGp/hgOUb4aJl/YcZpxGyIqS4SDfk7+pr+x4jjmTgV6M+
   OIVlxUg0+T6Y4BXL910dR9hAZ1tk+HDzaajZzQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=xrQUKwgb6ECTPjlBlSEf22t1XBCaqscdT/5AgJfTQIo=;
 b=GytjJJSNnBvtIcN65evTL+Ykn/iEEZpSnbHA7seQSZEEL0IgsEnBjDjDlBIV7ozMV8fwUkDukF7f
   RI2kWouk5yt0mV5dv1L5YG0LSfrQdGTFdV73yONMETlk9d94agvQQMC12L+A/YX49SMa8Z2RM0/F
   eqx/c8rFqZkXyA+pxiLYRKHNxu459aplAoY957UVt67YMBV2a+9AYyPOAFoUYsioPV2Fw9iCuzVt
   o2WbvWIn/dEslDsyY5ae7yIKqk3vMOOFmriZ/MSqN6TQve65sV/Xt3VMp/QzI6fr93XsP2brmTt1
   yzb4qDtqafbLILdv9t65ZXaQ+DYgsdhVFSlb1A==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD300C1OFZFQRE0@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 07 Jun 2022 06:14:03 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=intel.com; i=@intel.com;
 q=dns/txt; s=Intel; t=1654582430; x=1686118430;
 h=date:from:to:cc:subject:message-id:references: mime-version:in-reply-to;
 bh=pViZck3K1Rq0vF4B9iREn005L3q1DYrrwNaeY+v9f0c=;
 b=IKZkonRbudHjky1YgIXaJTFAyADo0vvbn3dFZwgsvUDP9/N2hxRA2sRX
 GiCuIaP/1K3uy5EYyIHGLlPRe9Wy4CWLAnyi3QyM9XckUov3rVy94qRUh
 BbZUOrbdLEyvnHUFvLOU9Uxy/hqN/ekNPs95rpt7qL6l99hwhw2lk4oNU
 VFek87NtLuUK89kYiEiluzK6c/PmFcLZl2Pvn0zLZgiVeGP+r8J5J6ln+
 6uEHMwa0Q9VGBbJDBn5SEKRa8cx9A3S3uYKWaiPDoV7IBmxQinJ/GbzYV
 4vyWD4sbzTXMhajf9Wvfv+yW5wwdWWPUxthfoc3rfe50sE3WezU8kyBSS g==;
Date: Tue, 7 Jun 2022 14:13:26 +0800
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 linux-fsdevel@vger.kernel.org
Message-id: <202206071414.41wGG8fp-lkp@intel.com>
References: <20220606204050.2625949-15-willy@infradead.org>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220606204050.2625949-15-willy@infradead.org>
X-Source-IP: 134.134.136.20
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10370
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 lowpriorityscore=0 priorityscore=253 malwarescore=0 impostorscore=0
 bulkscore=0 clxscore=229 suspectscore=0 adultscore=0 mlxlogscore=799
 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206070025 domainage_hfrom=13223
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 kbuild-all@lists.01.org, linux-ntfs-dev@lists.sourceforge.net,
 linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-block@vger.kernel.org, linux-mm@kvack.org,
 linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-ext4@vger.kernel.org, virtualization@lists.linux-foundation.org,
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH 14/20] hugetlb: Convert to migrate_folio
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
X-IronPort-AV: E=McAfee;i="6400,9594,10370"; a="264969054"
X-IronPort-AV: E=Sophos;i="5.91,282,1647327600"; d="scan'208";a="264969054"
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,282,1647327600"; d="scan'208";a="614746862"
X-ServerName: mga02.intel.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.intel.com include:_spf.google.com
 -all
X-Spam: Clean
X-Proofpoint-GUID: WbcIpa5n4IeGD6Btm9VhIlwHSrdOwktO
X-Proofpoint-ORIG-GUID: WbcIpa5n4IeGD6Btm9VhIlwHSrdOwktO
Reporting-Meta:
 AAETyMNTXccleHz3SzWtKbH+V7ox/Tb+yACXvIH65cyryp3T4OjkWHeenVUTgxIs
 mXCRrLDatEFvEWXgezvrFqqNEWOpKxcd3pHAFV/w2JZQFkc/Bd4suZJdgRpfYifM
 L+C0ktqBBiNlV3mpScLyeEcKO5vWtmsE8OIrjKyh0lWJ1olTsWoilLU1N99wZbQd
 BnMKQ9EjjEkf1HXTxe8yy+Y2fFwgQvkBWjBRHpfmJwysbUzmOoB+qqT7ia0TjXpM
 0z81mDNiS/AjloVsMA4Fqz8e74RU4fkeGqb+A/3gJCVq6jyul/jyd0w8zZCw4OiG
 haBy7VKPXJ1tg13ExrSt+FIlPcFYr6dC+CPsrDyuRcJ/fWrIOnUCFlLw2gTCbbqD
 0ANuY9SEcpU1mPsn7URlZRI8lDBq14dxjIj02xUTAxxIlNsM5sZ7bhgFL01LJ5ma
 4BAdw3EZ12vv+FBGGpTqxtggSf2wUB7VqVWZeTSe3FSt2W556Mr1tns5264dqHMa
 sQ8dBHt0nxoVsNcUFXgyjd3/2+upvaR8BCfp2JnP0+A=

Hi "Matthew,

I love your patch! Yet something to improve:

[auto build test ERROR on linus/master]
[also build test ERROR on v5.19-rc1 next-20220607]
[cannot apply to jaegeuk-f2fs/dev-test trondmy-nfs/linux-next kdave/for-next xfs-linux/for-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Matthew-Wilcox-Oracle/Convert-aops-migratepage-to-aops-migrate_folio/20220607-044509
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git f2906aa863381afb0015a9eb7fefad885d4e5a56
config: ia64-randconfig-r015-20220605 (https://download.01.org/0day-ci/archive/20220607/202206071414.41wGG8fp-lkp@intel.com/config)
compiler: ia64-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/b038962c9c8c2ab77c71dfba24356ce24bd7a242
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Matthew-Wilcox-Oracle/Convert-aops-migratepage-to-aops-migrate_folio/20220607-044509
        git checkout b038962c9c8c2ab77c71dfba24356ce24bd7a242
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=ia64 SHELL=/bin/bash fs/hugetlbfs/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   fs/hugetlbfs/inode.c: In function 'hugetlbfs_migrate_folio':
>> fs/hugetlbfs/inode.c:990:17: error: implicit declaration of function 'folio_migrate_copy' [-Werror=implicit-function-declaration]
     990 |                 folio_migrate_copy(dst, src);
         |                 ^~~~~~~~~~~~~~~~~~
>> fs/hugetlbfs/inode.c:992:17: error: implicit declaration of function 'folio_migrate_flags'; did you mean 'folio_mapping_flags'? [-Werror=implicit-function-declaration]
     992 |                 folio_migrate_flags(dst, src);
         |                 ^~~~~~~~~~~~~~~~~~~
         |                 folio_mapping_flags
   cc1: some warnings being treated as errors


vim +/folio_migrate_copy +990 fs/hugetlbfs/inode.c

   972	
   973	static int hugetlbfs_migrate_folio(struct address_space *mapping,
   974					struct folio *dst, struct folio *src,
   975					enum migrate_mode mode)
   976	{
   977		int rc;
   978	
   979		rc = migrate_huge_page_move_mapping(mapping, dst, src);
   980		if (rc != MIGRATEPAGE_SUCCESS)
   981			return rc;
   982	
   983		if (hugetlb_page_subpool(&src->page)) {
   984			hugetlb_set_page_subpool(&dst->page,
   985						hugetlb_page_subpool(&src->page));
   986			hugetlb_set_page_subpool(&src->page, NULL);
   987		}
   988	
   989		if (mode != MIGRATE_SYNC_NO_COPY)
 > 990			folio_migrate_copy(dst, src);
   991		else
 > 992			folio_migrate_flags(dst, src);
   993	
   994		return MIGRATEPAGE_SUCCESS;
   995	}
   996	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
