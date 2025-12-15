Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE4D831CA50;
	Mon, 15 Dec 2025 04:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765773856; cv=none; b=EalMvp9npkujXjnqhj+dqOOLFUFvRYqMZBi/+sGyQxdhiKlc4zeCvU6B0CNQoEfRY13l6BwDlN3KCblhj9+gI/4wJrUBjJyURO0TMiq/Q27XUNkO4gH8DIgvvE1hbA/7hdQhU6qjTDB9BucxiYgDSzGq0h2ORNkn5sILEISc3YU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765773856; c=relaxed/simple;
	bh=lSBw2rly7++DDGvNqiNsLpN7cpmDp4zMZ4rWrL7BcU0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nGSLnjmd8EuTl+Rwp9/6mIVoEyJouKTnvsfN5b1iKmpCqv2ozrUP/vWyl2ea1M2uIs+UY4/HYao0NmGhrTq02Sn94sBpNd3zqcCimspT929HiYE0bpgUBwED1+uVMZpkgOKCkQgE1VEVCiUKiA1Q7fC6AQ2DIbedH+aDyet+Ql8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Zvraj/3F; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Zvraj/3F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765773855; x=1797309855;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lSBw2rly7++DDGvNqiNsLpN7cpmDp4zMZ4rWrL7BcU0=;
  b=Zvraj/3FTIfEg8Q/49yq51Xj5c6badKQmVeJuzXW8U2hfDoBEovCgwzr
   sohzZmD3lslkow60t3h6kn0vkkz/1PAQkzHE2ATnr4PXrma/+wwAHIrNs
   05skJ5Rak3gES9S4q9jZA3TCyDCg1EPDbRzPysk8bNvZeWu/8b0jquujq
   Q1kHT2uFVGa+5cbPUTQ0yx7eShOpFJpR3fTIg25kUse+ZefD49G5vpGqY
   ek/8nsNY88KUlu8pjsobrXrc6Lna3Ef0gS8ZXrF4QNyBnCu1EqBf9/DK7
   abU+czfOSfvSVuU1MSNUSzmyMEPH/u15x5wCXIHqR9EBmoHJEUalN/c3F
   Q==;
X-CSE-ConnectionGUID: mhMyVbd4TvKewIEa1ztU6w==
X-CSE-MsgGUID: 4/jqY2JjSdyaUZbK660a3A==
X-IronPort-AV: E=McAfee;i="6800,10657,11642"; a="66852255"
X-IronPort-AV: E=Sophos;i="6.21,150,1763452800"; 
   d="scan'208";a="66852255"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2025 20:44:13 -0800
X-CSE-ConnectionGUID: kOw0mJ8/S6uRoZTy+TjT/Q==
X-CSE-MsgGUID: wuWJyBlESeC25kf2oL3WmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,150,1763452800"; 
   d="scan'208";a="228277783"
Received: from lkp-server01.sh.intel.com (HELO d335e3c6db51) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 14 Dec 2025 20:44:10 -0800
Received: from kbuild by d335e3c6db51 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vV0RM-000000009nT-2QAq;
	Mon, 15 Dec 2025 04:44:08 +0000
Date: Mon, 15 Dec 2025 12:44:07 +0800
From: kernel test robot <lkp@intel.com>
To: Prithvi Tambewagh <activprithvi@gmail.com>,
	syzbot+c818e5c4559444f88aa0@syzkaller.appspotmail.com,
	jlbec@evilplan.org, joseph.qi@linux.alibaba.com, mark@fasheh.com,
	heming.zhao@suse.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-kernel@vger.kernel.org, ocfs2-devel@lists.linux.dev,
	syzkaller-bugs@googlegroups.com,
	Prithvi Tambewagh <activprithvi@gmail.com>
Subject: Re: Syzbot test for v3: ocfs2: fix kernel BUG in ocfs2_write_block
Message-ID: <202512151201.4cweqZmR-lkp@intel.com>
References: <20251214192047.34811-1-activprithvi@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251214192047.34811-1-activprithvi@gmail.com>

Hi Prithvi,

kernel test robot noticed the following build errors:

[auto build test ERROR on 24172e0d79900908cf5ebf366600616d29c9b417]

url:    https://github.com/intel-lab-lkp/linux/commits/Prithvi-Tambewagh/Syzbot-test-for-v3-ocfs2-fix-kernel-BUG-in-ocfs2_write_block/20251215-032310
base:   24172e0d79900908cf5ebf366600616d29c9b417
patch link:    https://lore.kernel.org/r/20251214192047.34811-1-activprithvi%40gmail.com
patch subject: Syzbot test for v3: ocfs2: fix kernel BUG in ocfs2_write_block
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20251215/202512151201.4cweqZmR-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251215/202512151201.4cweqZmR-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512151201.4cweqZmR-lkp@intel.com/

All errors (new ones prefixed by >>):

>> fs/ocfs2/slot_map.c:48:31: error: expected ';' after top level declarator
      48 |                                           struct buffer_head *bh)
         |                                                                  ^
         |                                                                  ;
   1 error generated.


vim +48 fs/ocfs2/slot_map.c

    42	
    43	
    44	static int __ocfs2_node_num_to_slot(struct ocfs2_slot_info *si,
    45					    unsigned int node_num);
    46	
    47	static int ocfs2_validate_slot_map_block(struct super_block *sb,
  > 48						  struct buffer_head *bh)
    49	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
