Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA5FAC43334
	for <ocfs2-devel@archiver.kernel.org>; Tue,  7 Jun 2022 14:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=UN9WCh2ZcQ4xT6s8dq6Ug5eYRe0ADje/rvB4XDLk4Jk=;
 b=bmIc7LkSdegvJiWO2NZ65GdBa/L4VuwBlmE8u96QZLgbmjgDvKQvsx0koSdoDRtd6vj5oUaNXHEo
   KdODu8yzeF4lzAeMhq5LeMHj6jehSR9u2oe8kaO43Cvod7m1xVv8CNXz8lfDF0svXkBYfay/W0jN
   LWlBrut1qIC0o7PB/7u1ccppa1o/vQ940UOmrF+vT3nUyaF4yD9ubQoEAZ+QHzuFKIb11shig7Fz
   wIYGVy5vfzt0EECOa8iIXDbcTWsxv5bB7rLq6QCPEh2hPREDp6Jf8E7yljRoaDA5lD4nl2F8P/qp
   pFQ9Asbia7B4F/k5ceQdoyIN9p4Mdudllv6Trw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=UN9WCh2ZcQ4xT6s8dq6Ug5eYRe0ADje/rvB4XDLk4Jk=;
 b=klbGNeEoP33bkWTIi02pEZKF+NCZ1SwFDVxj8CNJEIpByHkmKnIfhaZm9M+X37Sw/t40Axgo9iil
   zOSmX87B1oYuwQUjr6DXGzCFSa6Hg7nWFr1a1kjQq/bSoi6lqwHf0r90f8z2k/rZexdc2H+mgc2Q
   xhzEgjCSDKwDiwNtmKSLwTQUi4eGhZ+dLtvaHoE+gRgAK8sz1oLIfbWMV3T1ky04wSwc8LNfhxSs
   fckkXdJGQ58P1+ZlrPWTdqJExsXJRDCotM4cTWC/ZZ+wOgbq8qHGqPX2ubCYVjMhVpvPLm3Y5Pzj
   PWuOJ3mg2/p8Zz0Fh3cYRlTPaZgU8pln6K3RtA==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD400O8648E9NC0@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 07 Jun 2022 14:57:50 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
 References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=AfL2iuaKMIW3GEEXa7GrCIERYid9+IWuPeOvvtY3ld4=; b=fRSk5WhSy4yx86ABGN8DAKmWjC
 5IdJfhP/2tfrBb3qOP67dWCLnwarcUWbjvi3CSZox73Cc2Y1PIwGlfqeGnF3Uxyt0mbA5Mg3BbAic
 u8C1w1Bg+HnPIgHl9bpnhpAGnvXoNlM/riGdn7iNiA4dEw1cH8c3GLB6l+j+CAh8jR4QCRLgjeJYJ
 KjvzVwo8asMupiPKaBH9YNKuxq1ZqBG33mo7YsQtWCkEXiw/2CPMhM29QfN4S2WqjmyhTpN+ujECh
 HLTSFWPPBpUYWjBGjh365kLciirfPTZ2IaAsMeDnES6CMIrk6IVPXnxuuFSWcG0n8eXm6dw3XUxLO
 bUTOI4Jw==;
Date: Tue, 7 Jun 2022 15:57:01 +0100
To: kernel test robot <lkp@intel.com>
Message-id: <Yp9nPSwPEWoX7Ml+@casper.infradead.org>
References: <20220606204050.2625949-5-willy@infradead.org>
 <202206071139.aWSx4GHH-lkp@intel.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <202206071139.aWSx4GHH-lkp@intel.com>
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10371
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
 malwarescore=0 bulkscore=0 adultscore=0 mlxscore=0 clxscore=157
 lowpriorityscore=0 phishscore=0 impostorscore=0 mlxlogscore=395 suspectscore=0
 priorityscore=165 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206070060 domainage_hfrom=8379
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 kbuild-all@lists.01.org, linux-ntfs-dev@lists.sourceforge.net,
 linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-block@vger.kernel.org, linux-mm@kvack.org,
 linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 virtualization@lists.linux-foundation.org, linux-xfs@vger.kernel.org,
 linux-btrfs@vger.kernel.org
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
From: Matthew Wilcox via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Matthew Wilcox <willy@infradead.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: casper.infradead.org
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: Jor-iP9zwOMqvSZF0DkeQ9ZsMcn5fpGF
X-Proofpoint-ORIG-GUID: Jor-iP9zwOMqvSZF0DkeQ9ZsMcn5fpGF
Reporting-Meta:
 AAEJ9/GjdivP2KowmX17yDYdsck74u+Plr+C3E1bgy1PRQ6XBrSTc31Jlpf1RAFB
 1zZ6EeFQhPFC0o4AFH9igdtG1agxpOgTG7hcxAE5OIq0C7fj1VojuxBTn7R4Vdfp
 D36BbmPGXt3jWILZZIeggotyuJwXZSY70ik+Qh70NK4IEAiZcj1T1mMSNu7THmUo
 VCi8iF/A7aCoAY+fRLi7A+2yXdZ2NJMRfWQl1AJZGpUmX3uELVDmu0VMlbdqzp/q
 3Vbx2Z5L6B30nFNhMv+UXq4MwwEasL3n/D7P4D6wyZ94mrS697I4T9keR0wfgvi8
 hkfnKlUZ09WXJx52EcgJoHorli3mkmKIsp67Bd2qmQ4/vhFzgIzrPidnat9d2+E6
 +EfnRliHhE6KpuPrS5BNyvlICBK2pRS583YZesznl+FMedRHmL5KYVuitcdopxMi
 kVOlqk9UGvES1vs4ZUMCuahQuzRy1CebKEwE33TuBAWJjW/4fs/3ZgA0kqRwlSP6
 5wNf7lrS91PCIXsGYnzPRXeSwq4GNHSdoVoKqozu0x1b

On Tue, Jun 07, 2022 at 11:37:45AM +0800, kernel test robot wrote:
> All warnings (new ones prefixed by >>):
> 
> >> mm/migrate.c:775: warning: expecting prototype for buffer_migrate_folio_noref(). Prototype was for buffer_migrate_folio_norefs() instead

No good deed (turning documentation into kerneldoc) goes unpunished ...
thanks, fixed.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
