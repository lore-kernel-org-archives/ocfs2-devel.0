Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3722D14F90;
	Thu, 19 Oct 2023 09:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ROHja2ae"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697709252; x=1729245252;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=DpWoKFS1wco1iGTyAsYaK+amZcKbFRnsbYOwb1MRs9M=;
  b=ROHja2aeh4isGBY/TWjLxJSyALGoV9R86Ha4y2nRR0sBndBk9aLojZBI
   hjsaW5mKa2Ti8YBPJ5nwuRfXtBq7gJ8BZH6+vRGfSLajYUPrnqZGsK2SB
   EB5ZUCyYUvGJQdIGKdupjEmVlMjH8UVsaXCTc22RvYcB9Cib7kindo13r
   euL2rwTaScvICdg7my7DP4u0WBdjRLHuvwcsfVTz/ZimRZueIOsBnBL/T
   r+2G/YHOHddKi8nltBOZe/RxeV+Mce0nM5JBX3m4aKZa4l4PnHWtRsqO8
   vNfuEF9/WVUiYwJJfqxSRDObhoWWzKdp8rp9nLIsy65jcVPo6dff63iiL
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10867"; a="365565816"
X-IronPort-AV: E=Sophos;i="6.03,236,1694761200"; 
   d="scan'208";a="365565816"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2023 02:54:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10867"; a="900681484"
X-IronPort-AV: E=Sophos;i="6.03,236,1694761200"; 
   d="scan'208";a="900681484"
Received: from lkp-server01.sh.intel.com (HELO 8917679a5d3e) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 19 Oct 2023 02:51:57 -0700
Received: from kbuild by 8917679a5d3e with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1qtPj7-0001wc-2L;
	Thu, 19 Oct 2023 09:54:01 +0000
Date: Thu, 19 Oct 2023 17:53:12 +0800
From: kernel test robot <lkp@intel.com>
To: KaiLong Wang <wangkailong@jari.cn>, mark@fasheh.com, jlbec@evilplan.org,
	akpm@linux-foundation.org
Cc: oe-kbuild-all@lists.linux.dev, ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ocfs2/dlm: Clean up errors in dlmdomain.c
Message-ID: <202310191736.myy5k3i6-lkp@intel.com>
References: <62e91e34.969.18b27f9ec40.Coremail.wangkailong@jari.cn>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62e91e34.969.18b27f9ec40.Coremail.wangkailong@jari.cn>

Hi KaiLong,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]
[also build test WARNING on linus/master v6.6-rc6 next-20231019]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/KaiLong-Wang/ocfs2-dlm-Clean-up-errors-in-dlmdomain-c/20231017-115916
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/62e91e34.969.18b27f9ec40.Coremail.wangkailong%40jari.cn
patch subject: [PATCH] ocfs2/dlm: Clean up errors in dlmdomain.c
config: sh-allmodconfig (https://download.01.org/0day-ci/archive/20231019/202310191736.myy5k3i6-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231019/202310191736.myy5k3i6-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202310191736.myy5k3i6-lkp@intel.com/

All warnings (new ones prefixed by >>):

   fs/ocfs2/dlm/dlmdomain.c: In function 'dlm_alloc_pagevec':
   fs/ocfs2/dlm/dlmdomain.c:78:9: warning: this 'for' clause does not guard... [-Wmisleading-indentation]
      78 |         for (i = 0; i < pages; i++)
         |         ^~~
   fs/ocfs2/dlm/dlmdomain.c:80:17: note: ...this statement, but the latter is misleadingly indented as if it were guarded by the 'for'
      80 |                 if (!(vec[i]))
         |                 ^~
   fs/ocfs2/dlm/dlmdomain.c: In function 'dlm_alloc_pagevec.constprop':
>> fs/ocfs2/dlm/dlmdomain.c:80:26: warning: array subscript 32 is outside array bounds of 'void[128]' [-Warray-bounds=]
      80 |                 if (!(vec[i]))
         |                      ~~~~^~~~
   In file included from fs/ocfs2/dlm/dlmdomain.c:12:
   In function 'kmalloc',
       inlined from 'kmalloc_array' at include/linux/slab.h:635:10,
       inlined from 'dlm_alloc_pagevec.constprop' at fs/ocfs2/dlm/dlmdomain.c:72:15:
   include/linux/slab.h:599:24: note: at offset 128 into object of size 128 allocated by 'kmalloc_trace'
     599 |                 return kmalloc_trace(
         |                        ^~~~~~~~~~~~~~
     600 |                                 kmalloc_caches[kmalloc_type(flags, _RET_IP_)][index],
         |                                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     601 |                                 flags, size);
         |                                 ~~~~~~~~~~~~


vim +80 fs/ocfs2/dlm/dlmdomain.c

    69	
    70	static void **dlm_alloc_pagevec(int pages)
    71	{
    72		void **vec = kmalloc_array(pages, sizeof(void *), GFP_KERNEL);
    73		int i;
    74	
    75		if (!vec)
    76			return NULL;
    77	
    78		for (i = 0; i < pages; i++)
    79			vec[i] = (void *)__get_free_page(GFP_KERNEL);
  > 80			if (!(vec[i]))
    81				goto out_free;
    82	
    83		mlog(0, "Allocated DLM hash pagevec; %d pages (%lu expected), %lu buckets per page\n",
    84		     pages, (unsigned long)DLM_HASH_PAGES,
    85		     (unsigned long)DLM_BUCKETS_PER_PAGE);
    86		return vec;
    87	out_free:
    88		dlm_free_pagevec(vec, i);
    89		return NULL;
    90	}
    91	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
