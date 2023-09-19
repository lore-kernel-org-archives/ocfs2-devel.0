Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB922905;
	Tue, 19 Sep 2023 19:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695150009; x=1726686009;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+sS+JNmoHLMHmoY3ifeSMQHL71aCGWfQ89oWz/WEOJ8=;
  b=LhP9oVFjSui/o4uBYHPrew7pTOk6347zOD/rJ6GTf8ekyr9Z9mJnHZku
   Ki55cr0p4IGqPzAInL2y6526yNmYl2CrnD6Kc5mxa4w9MXiI0HiNCPzfZ
   rHn7xK9YmY6oj3cFY/vGvYzjhK+iHQo6cy9feGSkA1W6T6sv/q2+0KkkG
   fo+iDpeMqjehgGMq0FyPSJ0eAMO3V53oH6CPYFqyzZa3E4ZQx05+cY17y
   irgLYKuIeZC/U7k6W1yGMIbCEosFmjcFJq/DMaZBs7py79EPUeekxRlGE
   Y182+AMltHbrzHMcY8f7WBZKbOvfbxmPcmpX25ay98U3jgaSnDbiOJiFu
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10838"; a="377335261"
X-IronPort-AV: E=Sophos;i="6.02,160,1688454000"; 
   d="scan'208";a="377335261"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2023 12:00:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10838"; a="749601584"
X-IronPort-AV: E=Sophos;i="6.02,160,1688454000"; 
   d="scan'208";a="749601584"
Received: from lkp-server02.sh.intel.com (HELO 9ef86b2655e5) ([10.239.97.151])
  by fmsmga007.fm.intel.com with ESMTP; 19 Sep 2023 12:00:05 -0700
Received: from kbuild by 9ef86b2655e5 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1qifx4-0007oq-2w;
	Tue, 19 Sep 2023 19:00:02 +0000
Date: Wed, 20 Sep 2023 02:59:48 +0800
From: kernel test robot <lkp@intel.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-fsdevel@vger.kernel.org, gfs2@lists.linux.dev,
	linux-nilfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net,
	ntfs3@lists.linux.dev, ocfs2-devel@lists.linux.dev,
	reiserfs-devel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [PATCH 11/26] nilfs2: Convert nilfs_copy_page() to
 nilfs_copy_folio()
Message-ID: <202309200252.NpD8SUsn-lkp@intel.com>
References: <20230919045135.3635437-12-willy@infradead.org>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230919045135.3635437-12-willy@infradead.org>

Hi Matthew,

kernel test robot noticed the following build errors:

[auto build test ERROR on next-20230918]
[also build test ERROR on v6.6-rc2]
[cannot apply to konis-nilfs2/upstream gfs2/for-next tytso-ext4/dev linus/master v6.6-rc2 v6.6-rc1 v6.5]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Matthew-Wilcox-Oracle/buffer-Make-folio_create_empty_buffers-return-a-buffer_head/20230919-125330
base:   next-20230918
patch link:    https://lore.kernel.org/r/20230919045135.3635437-12-willy%40infradead.org
patch subject: [PATCH 11/26] nilfs2: Convert nilfs_copy_page() to nilfs_copy_folio()
config: s390-defconfig (https://download.01.org/0day-ci/archive/20230920/202309200252.NpD8SUsn-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20230920/202309200252.NpD8SUsn-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202309200252.NpD8SUsn-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/net/amt.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/net/macvtap.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/net/tap.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/net/ppp/ppp_generic.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/net/ppp/ppp_async.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/net/ppp/bsd_comp.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/net/ppp/ppp_deflate.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/net/ppp/ppp_synctty.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/net/slip/slhc.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/cdrom/cdrom.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/s390/cio/vfio_ccw.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/s390/block/dcssblk.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/s390/net/lcs.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/802/garp.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sched/act_gate.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sched/sch_htb.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sched/sch_hfsc.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sched/sch_red.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sched/sch_gred.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sched/sch_ingress.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sched/sch_sfq.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sched/sch_tbf.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sched/sch_teql.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sched/sch_prio.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sched/sch_multiq.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sched/sch_netem.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sched/sch_drr.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sched/sch_plug.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sched/sch_ets.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sched/sch_mqprio.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sched/sch_mqprio_lib.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sched/sch_choke.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sched/sch_qfq.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sched/cls_u32.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sched/cls_route.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sched/cls_fw.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sched/cls_basic.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/netlink/netlink_diag.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/netfilter/nfnetlink_osf.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/netfilter/nf_conntrack.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/netfilter/nf_conntrack_netlink.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/netfilter/nf_conntrack_broadcast.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/netfilter/nf_nat.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/netfilter/nf_tables.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/netfilter/nft_fib.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/netfilter/nft_chain_nat.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/netfilter/ipvs/ip_vs.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/netfilter/ipvs/ip_vs_rr.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/netfilter/ipvs/ip_vs_wrr.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/netfilter/ipvs/ip_vs_lc.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/netfilter/ipvs/ip_vs_wlc.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/netfilter/ipvs/ip_vs_lblc.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/netfilter/ipvs/ip_vs_lblcr.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/netfilter/ipvs/ip_vs_dh.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/netfilter/ipvs/ip_vs_sh.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/netfilter/ipvs/ip_vs_sed.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/netfilter/ipvs/ip_vs_nq.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/netfilter/ipvs/ip_vs_twos.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/netfilter/ipvs/ip_vs_ftp.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/netfilter/ipvs/ip_vs_pe_sip.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv4/netfilter/nf_defrag_ipv4.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv4/netfilter/nf_reject_ipv4.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv4/netfilter/iptable_nat.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv4/netfilter/iptable_raw.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv4/ip_tunnel.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv4/ipip.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv4/ip_gre.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv4/udp_tunnel.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv4/ip_vti.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv4/ah4.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv4/esp4.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv4/xfrm4_tunnel.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv4/tunnel4.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv4/inet_diag.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv4/tcp_diag.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv4/udp_diag.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/xfrm/xfrm_algo.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/xfrm/xfrm_user.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/unix/unix_diag.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv6/netfilter/ip6table_raw.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv6/netfilter/ip6table_nat.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv6/netfilter/nf_defrag_ipv6.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv6/netfilter/nf_reject_ipv6.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv6/ah6.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv6/esp6.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv6/xfrm6_tunnel.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv6/tunnel6.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv6/mip6.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv6/sit.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv6/ip6_udp_tunnel.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/packet/af_packet_diag.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/8021q/8021q.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/mptcp/mptcp_diag.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/key/af_key.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sunrpc/sunrpc.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sunrpc/auth_gss/auth_rpcgss.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sunrpc/auth_gss/rpcsec_gss_krb5.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sctp/sctp_diag.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/smc/smc_diag.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/vmw_vsock/vsock_diag.o
>> ERROR: modpost: "folio_copy" [fs/nilfs2/nilfs2.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
