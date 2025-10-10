Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2541C5D7D;
	Fri, 10 Oct 2025 00:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760057603; cv=none; b=sUY7+g/ykUdUIAkvVrN443Yt4wRGKen+LZ20CiQ1YWwfhYESYIsV+IMAoLHfNU4HbTwPSZ14riPahNc5xwVZSYFjZLcntipa0Qmuzs24mAOFr4asWl4U5Cq8HlLtNhaUKtYGeAeKP3aYNzM3WatiiqW2selbshDl/mbVV/n+ju4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760057603; c=relaxed/simple;
	bh=Wga/aebCRWdiAWHpaU8AXh6U7vsHDFqO9Xvrom8jolo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OE6xeoJ1Q420L5VWNywxhj3WKldiZVbteXz1LTjmrdKY7LiyJWq7WJdETzt5SX63OX10ndDn/W42BUAhOyOCR3bon4iU7VrZ6cgKT8LlSFylJlPCf04Z3piBlXSljh+jFGBnG3ekTjdHVAbhzDjXuDjwdktbh//k2AGWGL8EgaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fwpikYRL; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fwpikYRL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760057601; x=1791593601;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Wga/aebCRWdiAWHpaU8AXh6U7vsHDFqO9Xvrom8jolo=;
  b=fwpikYRLl7RCDwQCCPA95R5jpE068SUKCjLeJNv1yO7AuL//ZE2DWXfq
   hDG7pxGsWKEnuLaf/s/lxFG71iwLY3Eywlw+Y0Xnu3DNmJuhbidSuCZaH
   ABkPQvaHe2iSOnFRqwRdhQDn4ohP968/bdR0qDkZHe3OBIRbVMRgx+I/q
   3f44a07Eg0Oke2b5MwLl1aUj9UD0zPA8jwkVPnSvFXGm3TycUlZwommS/
   h0pQfoe9Kyli8Y+oH5SMx+hvOTu+I4Rn27Y0KdncOkc9SbDZK7qawD3th
   +MiTf9GuikHKbOj+0utBeE2jpfn8yt4yfTBZFpu5+wVqv05RrFjJKvvMt
   Q==;
X-CSE-ConnectionGUID: oFspPeOlR7advOjOiMF8pw==
X-CSE-MsgGUID: pECS5GhTTrWs9R0xBYaRSQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11577"; a="64898213"
X-IronPort-AV: E=Sophos;i="6.19,217,1754982000"; 
   d="scan'208";a="64898213"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2025 17:53:20 -0700
X-CSE-ConnectionGUID: 4QLDYU65SZGnRrRsXlGYEw==
X-CSE-MsgGUID: UDeu69kFRyqGchrUMdhs5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,217,1754982000"; 
   d="scan'208";a="211497284"
Received: from lkp-server01.sh.intel.com (HELO 6a630e8620ab) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 09 Oct 2025 17:53:17 -0700
Received: from kbuild by 6a630e8620ab with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v71Ni-0001h5-2H;
	Fri, 10 Oct 2025 00:53:14 +0000
Date: Fri, 10 Oct 2025 08:52:17 +0800
From: kernel test robot <lkp@intel.com>
To: ssrane_b23@ee.vjti.ac.in, Mark Fasheh <mark@fasheh.com>
Cc: oe-kbuild-all@lists.linux.dev, Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
	syzbot+30b53487d00b4f7f0922@syzkaller.appspotmail.com,
	Shaurya Rane <ssrane_b23@ee.vjti.ac.in>
Subject: Re: [PATCH] ocfs2: Fix use-after-free in ocfs2_dx_dir_lookup_rec
Message-ID: <202510100838.uqgonWvJ-lkp@intel.com>
References: <20251005151403.9012-1-ssranevjti@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251005151403.9012-1-ssranevjti@gmail.com>

Hi,

kernel test robot noticed the following build warnings:

[auto build test WARNING on brauner-vfs/vfs.all]
[also build test WARNING on linus/master v6.17 next-20251009]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/ssrane_b23-ee-vjti-ac-in/ocfs2-Fix-use-after-free-in-ocfs2_dx_dir_lookup_rec/20251009-163456
base:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git vfs.all
patch link:    https://lore.kernel.org/r/20251005151403.9012-1-ssranevjti%40gmail.com
patch subject: [PATCH] ocfs2: Fix use-after-free in ocfs2_dx_dir_lookup_rec
config: m68k-allyesconfig (https://download.01.org/0day-ci/archive/20251010/202510100838.uqgonWvJ-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251010/202510100838.uqgonWvJ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510100838.uqgonWvJ-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from fs/ocfs2/dir.c:45:
   fs/ocfs2/dir.c: In function 'ocfs2_dx_dir_lookup_rec':
>> fs/ocfs2/dir.c:821:35: warning: format '%u' expects argument of type 'unsigned int', but argument 5 has type 'long long unsigned int' [-Wformat=]
     821 |                                   "Inode %lu has bad extent record (%u, %u, 0) in btree\n",
         |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     822 |                                   inode->i_ino,
     823 |                                   eb_bh ? (unsigned long long)eb_bh->b_blocknr : 0);
         |                                   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
         |                                                                                |
         |                                                                                long long unsigned int
   fs/ocfs2/super.h:18:48: note: in definition of macro 'ocfs2_error'
      18 |         __ocfs2_error(sb, __PRETTY_FUNCTION__, fmt, ##__VA_ARGS__)
         |                                                ^~~
   fs/ocfs2/dir.c:821:70: note: format string is defined here
     821 |                                   "Inode %lu has bad extent record (%u, %u, 0) in btree\n",
         |                                                                     ~^
         |                                                                      |
         |                                                                      unsigned int
         |                                                                     %llu
>> fs/ocfs2/dir.c:821:35: warning: format '%u' expects a matching 'unsigned int' argument [-Wformat=]
     821 |                                   "Inode %lu has bad extent record (%u, %u, 0) in btree\n",
         |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   fs/ocfs2/super.h:18:48: note: in definition of macro 'ocfs2_error'
      18 |         __ocfs2_error(sb, __PRETTY_FUNCTION__, fmt, ##__VA_ARGS__)
         |                                                ^~~
   fs/ocfs2/dir.c:821:74: note: format string is defined here
     821 |                                   "Inode %lu has bad extent record (%u, %u, 0) in btree\n",
         |                                                                         ~^
         |                                                                          |
         |                                                                          unsigned int


vim +821 fs/ocfs2/dir.c

316f4b9f98a353a Mark Fasheh       2007-09-07  768  
9b7895efac906d6 Mark Fasheh       2008-11-12  769  static int ocfs2_dx_dir_lookup_rec(struct inode *inode,
9b7895efac906d6 Mark Fasheh       2008-11-12  770  				   struct ocfs2_extent_list *el,
9b7895efac906d6 Mark Fasheh       2008-11-12  771  				   u32 major_hash,
9b7895efac906d6 Mark Fasheh       2008-11-12  772  				   u32 *ret_cpos,
9b7895efac906d6 Mark Fasheh       2008-11-12  773  				   u64 *ret_phys_blkno,
9b7895efac906d6 Mark Fasheh       2008-11-12  774  				   unsigned int *ret_clen)
23193e513d1cd69 Mark Fasheh       2007-09-12  775  {
9b7895efac906d6 Mark Fasheh       2008-11-12  776  	int ret = 0, i, found;
9b7895efac906d6 Mark Fasheh       2008-11-12  777  	struct buffer_head *eb_bh = NULL;
9b7895efac906d6 Mark Fasheh       2008-11-12  778  	struct ocfs2_extent_block *eb;
9b7895efac906d6 Mark Fasheh       2008-11-12  779  	struct ocfs2_extent_rec *rec = NULL;
23193e513d1cd69 Mark Fasheh       2007-09-12  780  
9b7895efac906d6 Mark Fasheh       2008-11-12  781  	if (el->l_tree_depth) {
facdb77f54f09a3 Joel Becker       2009-02-12  782  		ret = ocfs2_find_leaf(INODE_CACHE(inode), el, major_hash,
facdb77f54f09a3 Joel Becker       2009-02-12  783  				      &eb_bh);
9b7895efac906d6 Mark Fasheh       2008-11-12  784  		if (ret) {
9b7895efac906d6 Mark Fasheh       2008-11-12  785  			mlog_errno(ret);
9b7895efac906d6 Mark Fasheh       2008-11-12  786  			goto out;
9b7895efac906d6 Mark Fasheh       2008-11-12  787  		}
23193e513d1cd69 Mark Fasheh       2007-09-12  788  
9b7895efac906d6 Mark Fasheh       2008-11-12  789  		eb = (struct ocfs2_extent_block *) eb_bh->b_data;
9b7895efac906d6 Mark Fasheh       2008-11-12  790  		el = &eb->h_list;
4a12ca3a00a244e Mark Fasheh       2008-11-12  791  
9b7895efac906d6 Mark Fasheh       2008-11-12  792  		if (el->l_tree_depth) {
17a5b9ab32fe046 Goldwyn Rodrigues 2015-09-04  793  			ret = ocfs2_error(inode->i_sb,
7ecef14ab1db961 Joe Perches       2015-09-04  794  					  "Inode %lu has non zero tree depth in btree tree block %llu\n",
7ecef14ab1db961 Joe Perches       2015-09-04  795  					  inode->i_ino,
9b7895efac906d6 Mark Fasheh       2008-11-12  796  					  (unsigned long long)eb_bh->b_blocknr);
9b7895efac906d6 Mark Fasheh       2008-11-12  797  			goto out;
9b7895efac906d6 Mark Fasheh       2008-11-12  798  		}
23193e513d1cd69 Mark Fasheh       2007-09-12  799  	}
23193e513d1cd69 Mark Fasheh       2007-09-12  800  
44acc46d182ff36 Ivan Pravdin      2025-07-07  801  	if (le16_to_cpu(el->l_next_free_rec) == 0) {
44acc46d182ff36 Ivan Pravdin      2025-07-07  802  		ret = ocfs2_error(inode->i_sb,
44acc46d182ff36 Ivan Pravdin      2025-07-07  803  				  "Inode %lu has empty extent list at depth %u\n",
44acc46d182ff36 Ivan Pravdin      2025-07-07  804  				  inode->i_ino,
44acc46d182ff36 Ivan Pravdin      2025-07-07  805  				  le16_to_cpu(el->l_tree_depth));
44acc46d182ff36 Ivan Pravdin      2025-07-07  806  		goto out;
44acc46d182ff36 Ivan Pravdin      2025-07-07  807  	}
44acc46d182ff36 Ivan Pravdin      2025-07-07  808  
9b7895efac906d6 Mark Fasheh       2008-11-12  809  	found = 0;
9b7895efac906d6 Mark Fasheh       2008-11-12  810  	for (i = le16_to_cpu(el->l_next_free_rec) - 1; i >= 0; i--) {
9b7895efac906d6 Mark Fasheh       2008-11-12  811  		rec = &el->l_recs[i];
9b7895efac906d6 Mark Fasheh       2008-11-12  812  
9b7895efac906d6 Mark Fasheh       2008-11-12  813  		if (le32_to_cpu(rec->e_cpos) <= major_hash) {
9b7895efac906d6 Mark Fasheh       2008-11-12  814  			found = 1;
9b7895efac906d6 Mark Fasheh       2008-11-12  815  			break;
9b7895efac906d6 Mark Fasheh       2008-11-12  816  		}
9b7895efac906d6 Mark Fasheh       2008-11-12  817  	}
9b7895efac906d6 Mark Fasheh       2008-11-12  818  
9b7895efac906d6 Mark Fasheh       2008-11-12  819  	if (!found) {
7ecef14ab1db961 Joe Perches       2015-09-04  820  		ret = ocfs2_error(inode->i_sb,
7ecef14ab1db961 Joe Perches       2015-09-04 @821  				  "Inode %lu has bad extent record (%u, %u, 0) in btree\n",
7ecef14ab1db961 Joe Perches       2015-09-04  822  				  inode->i_ino,
82a88475c352f95 Shaurya Rane      2025-10-05  823  				  eb_bh ? (unsigned long long)eb_bh->b_blocknr : 0);
9b7895efac906d6 Mark Fasheh       2008-11-12  824  		goto out;
9b7895efac906d6 Mark Fasheh       2008-11-12  825  	}
9b7895efac906d6 Mark Fasheh       2008-11-12  826  
9b7895efac906d6 Mark Fasheh       2008-11-12  827  	if (ret_phys_blkno)
9b7895efac906d6 Mark Fasheh       2008-11-12  828  		*ret_phys_blkno = le64_to_cpu(rec->e_blkno);
9b7895efac906d6 Mark Fasheh       2008-11-12  829  	if (ret_cpos)
9b7895efac906d6 Mark Fasheh       2008-11-12  830  		*ret_cpos = le32_to_cpu(rec->e_cpos);
9b7895efac906d6 Mark Fasheh       2008-11-12  831  	if (ret_clen)
9b7895efac906d6 Mark Fasheh       2008-11-12  832  		*ret_clen = le16_to_cpu(rec->e_leaf_clusters);
9b7895efac906d6 Mark Fasheh       2008-11-12  833  
9b7895efac906d6 Mark Fasheh       2008-11-12  834  out:
9b7895efac906d6 Mark Fasheh       2008-11-12  835  	brelse(eb_bh);
9b7895efac906d6 Mark Fasheh       2008-11-12  836  	return ret;
9b7895efac906d6 Mark Fasheh       2008-11-12  837  }
38760e243249f03 Mark Fasheh       2007-09-11  838  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
