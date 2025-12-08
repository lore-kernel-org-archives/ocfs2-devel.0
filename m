Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0025627E066;
	Mon,  8 Dec 2025 19:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765221123; cv=none; b=b3qelTKCHOAgO9MU4mFZwmxq48hdZOSgN+ouGWLL7CtVC2dtnQWw453LgG6gPlTTut9AiGxsMLTuX3J0rqjRlVl65sBwKQsqw9FCYRJtTwMP5ojXh+t/vT/gc4dEwnsPmPhHQHbrQjkZooXDLADwv6GcpbrJ2/D1Z++CzS6PGaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765221123; c=relaxed/simple;
	bh=4GJXL/LoLHx7N2a8v5VWshnzbRCiIknwAktZdBjLWzs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qrBBp6yquQN3jXfK8MF6aWZt8QkIWiKB71XBK1nDV+fTyOwkM4tTEett5DAYxU3NLwGzyy/apMI0ZdHyc5vIifmi3BAeQF5Mb29dXWdlpRu0uTE+2stdw4TWiwLFOPUG1fbifHBhLL3qycYBd5fBqlwHHBgxL+lqFwTSoGDKxfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=djkd0x8R; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="djkd0x8R"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765221122; x=1796757122;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4GJXL/LoLHx7N2a8v5VWshnzbRCiIknwAktZdBjLWzs=;
  b=djkd0x8RG4iNyONw9rVIvrCxj2HiCVZ1YzWh2OWwX9AmAnj03tvfWLEO
   Nyt5l9UQZx4x7/3viEQe13oLAemh06dUCUyQGS+ZJrnqmd1/yFAzj0OcI
   HXLiRW4iGsCyifHZmbbgHIxhpJ+zmT23ZQZgAqYbsGvCBkFlqFf3/kpwN
   s7ehDnM1mae1XfCGmkGUOTTcrq+hcx5mrtrjPfqcuDVteKy+bef+P2d5d
   IazuKecCcNaEfYBopEffrKaTSgXROzoa0I+Owi7uMrhjKldhkvp96Wn8u
   nJ18SYVVN7m/veLLHKwVWk1ReWtrVYenYbUmSHwqid2j5HJBc4epkZ3fx
   A==;
X-CSE-ConnectionGUID: jqYluo9yQiSicN2znDBggw==
X-CSE-MsgGUID: f5KrfOMvQq+fyOI41EvuXg==
X-IronPort-AV: E=McAfee;i="6800,10657,11636"; a="54711468"
X-IronPort-AV: E=Sophos;i="6.20,259,1758610800"; 
   d="scan'208";a="54711468"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 11:12:02 -0800
X-CSE-ConnectionGUID: dIpHVU1eQw2pTfwkXgE9tQ==
X-CSE-MsgGUID: K8sgQq9xRsiatQ/7I2vP3g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,259,1758610800"; 
   d="scan'208";a="200177196"
Received: from lkp-server01.sh.intel.com (HELO d335e3c6db51) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 08 Dec 2025 11:11:58 -0800
Received: from kbuild by d335e3c6db51 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vSgeJ-000000000kR-0L12;
	Mon, 08 Dec 2025 19:11:55 +0000
Date: Tue, 9 Dec 2025 03:11:32 +0800
From: kernel test robot <lkp@intel.com>
To: Prithvi Tambewagh <activprithvi@gmail.com>, mark@fasheh.com,
	jlbec@evilplan.org, joseph.qi@linux.alibaba.com
Cc: oe-kbuild-all@lists.linux.dev, ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev,
	skhan@linuxfoundation.org, david.hunter.linux@gmail.com,
	khalid@kernel.org, Prithvi Tambewagh <activprithvi@gmail.com>,
	syzbot+c818e5c4559444f88aa0@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] ocfs2: Fix kernel BUG in ocfs2_write_block
Message-ID: <202512090210.evJEJv5b-lkp@intel.com>
References: <20251206154819.175479-1-activprithvi@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251206154819.175479-1-activprithvi@gmail.com>

Hi Prithvi,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 24172e0d79900908cf5ebf366600616d29c9b417]

url:    https://github.com/intel-lab-lkp/linux/commits/Prithvi-Tambewagh/ocfs2-Fix-kernel-BUG-in-ocfs2_write_block/20251206-235042
base:   24172e0d79900908cf5ebf366600616d29c9b417
patch link:    https://lore.kernel.org/r/20251206154819.175479-1-activprithvi%40gmail.com
patch subject: [PATCH] ocfs2: Fix kernel BUG in ocfs2_write_block
config: loongarch-randconfig-r112-20251207 (https://download.01.org/0day-ci/archive/20251209/202512090210.evJEJv5b-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 12.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251209/202512090210.evJEJv5b-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512090210.evJEJv5b-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> fs/ocfs2/slot_map.c:197:26: sparse: sparse: cast to restricted __le16
>> fs/ocfs2/slot_map.c:197:26: sparse: sparse: cast to restricted __le16

vim +197 fs/ocfs2/slot_map.c

   182	
   183	static int ocfs2_update_disk_slot(struct ocfs2_super *osb,
   184					  struct ocfs2_slot_info *si,
   185					  int slot_num)
   186	{
   187		int status;
   188		struct buffer_head *bh;
   189	
   190		spin_lock(&osb->osb_lock);
   191		if (si->si_extended)
   192			ocfs2_update_disk_slot_extended(si, slot_num, &bh);
   193		else
   194			ocfs2_update_disk_slot_old(si, slot_num, &bh);
   195		spin_unlock(&osb->osb_lock);
   196		if (bh->b_blocknr < OCFS2_SUPER_BLOCK_BLKNO) {
 > 197			status = ocfs2_error(osb->sb,
   198					     "Invalid Slot Map Buffer Head "
   199					     "Block Number : %llu, Should be >= %d",
   200					     le16_to_cpu(bh->b_blocknr),
   201					     le16_to_cpu((int)OCFS2_SUPER_BLOCK_BLKNO));
   202			if (!status)
   203				return -EIO;
   204			return status;
   205		}
   206	
   207		status = ocfs2_write_block(osb, bh, INODE_CACHE(si->si_inode));
   208		if (status < 0)
   209			mlog_errno(status);
   210	
   211		return status;
   212	}
   213	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
