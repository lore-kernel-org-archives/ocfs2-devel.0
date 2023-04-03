Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F694C761A6
	for <ocfs2-devel@archiver.kernel.org>; Mon,  3 Apr 2023 06:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=KbIDXfNA3KLyTZrTvSvs+1acNvcaVzQU1gbZ+eo0IL8=;
 b=A/nQcu9R/gJVAg+KT+gurgFuaHhknH7mhJMza099m6vrw3k0bNZpOuegbA18c7DHCSMn3+FTtsMx
   FkhyXZ5MvjLdcCQ38QTUmYoUrREf5GaxkZcTwZu3uyzOhE88C20o3NiRFVs9QyrRTo/B07Cwe2LJ
   ooVJtFky+rWW1wkMvJP7UpHcN8JB8YVtKO//taGngPvuA+BW5tr5ihzbKGsnfkQ2hYsO2KphpRH9
   W6357eind8xB/D9QkSrrImC0xDo+k6utoAS+tBZvGT6t+pz/8XlAsIX6FzNGXripFvGW9yiueFuY
   k8blTkFhOtDZEZw/cdqHdejBJliVjni4V2jtPQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=KbIDXfNA3KLyTZrTvSvs+1acNvcaVzQU1gbZ+eo0IL8=;
 b=HOf5edywM6kN+4uzaAJ6WzWm4Jd203RwCJ/Xse2duLnwYYFI1rSF8EV+yMVYHU5r4zWl1xwvbCJ6
   y9p3xPh+w6fZsCrCxowAp2ihbPmitiq108mx8+NWts3X6aFLIgrm41QJmWHXAS3wZZD5bGS40uaO
   l11ODGbq04Oinr6gXKs7YrY/z+75ELqnX3eDztGJY/sEfPm/ZtC1Zm6Ik7h8++cdPWqpfMHUfo6v
   qBhakN1ltfkJFL5oA0AKX6WNUXVtd81ZgK2RMH2fft+qmirRDz3uxs/1abw0wAAI6YK46IMDAdGe
   1zItafmSvjPOBaQTkawo2NAaMX4wrVSgWA5egw==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230317 64bit (built Mar 17
 2023))
 with ESMTPS id <0RSJ0059T00O6KC0@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 03 Apr 2023 06:14:48 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 t=1680502471;
 h=content-disposition:mime-version:message-id:subject:cc:to:from:date
 :from:to:cc:subject:date:message-id:reply-to;
 bh=bVeCXy+GBi88X47vUp2kci/ua0r4Qmm4tGxxhSCn7+s=;
 b=C6OSI3+zC0WBr/2T+Mm/rvlpWMEnrlVbbcvMc+X7ZkMi3VQfvvnj+laGh3f0R6gwfP
 ZSsdnPJ2vREsj6jPyWbTmxd18ClFHkVhu+eNPcjN0M0aO9KxKDIKvqbQf4XwPd9kDNIQ
 wfvA+mFrRnX7RE2TiIiCI4j685Ftzv1nCPkriCttcK8eNn27YvKwUpm0Pe9odOMJWliw
 mN4yoafY5gAD8MybxYWwsTyhRsxOHJEurMjvxFZl18WPvLJBt8GrbwzJsakqeO65bMws
 5JBN0B+mPrDdXf0YwpmEKcdCtxjqn35dKyz10oSeEAQ+Tu+d2Ev9A1fNsqvULzuf9/Ex jo/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20210112; t=1680502471;
 h=content-disposition:mime-version:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=bVeCXy+GBi88X47vUp2kci/ua0r4Qmm4tGxxhSCn7+s=;
 b=0FX1M4jV9av3c7W9X4rZxaZ60LEqzVrMLOXIJQYsNg+pmNJlc4mmYwxxTYYArsrqjV
 UWRI/P+t8dhhQ3SHrnhQ/Tq+N44bOm/y8pPbsKmHJ2wwEN7eleNY9q4oPC6dWHXjarUD
 OwNxnX88WADQf5NLGd/ey7F0QFNbzXmwkbnkWsfU3x0tdmUJvUR4J+pp4DxVDBWKEuRa
 KZeSVyml7Cz04ObRtUv/rkgfewY6JAQh9F+bAkcls5m5ZPkqst6WMrzAwHbDzbdS0zQg
 1Co01mEOfiMbWO68J7oKwrDjWBJcRdYr91eIoUh1WlkjRP82G8eSWX3+K4pAWkT08tE8 r/aw==
X-Gm-Message-State: AAQBX9ee5RfN9Dn/kxNwRsOutbFvD1Iln8ybKHiPvb0mcBF4ug9NjHo+
 BHI0SIS4tlgex/FHvCuDRwU=
X-Received: by 2002:a17:907:3f15:b0:947:735b:fcbe with SMTP id
 hq21-20020a1709073f1500b00947735bfcbemr16186074ejc.19.1680502471396; Sun,
 02 Apr 2023 23:14:31 -0700 (PDT)
Date: Mon, 3 Apr 2023 09:14:27 +0300
To: oe-kbuild@lists.linux.dev,
 Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Message-id: <9e1d6835-34fc-49cd-869e-d99d9b546d17@kili.mountain>
MIME-version: 1.0
Content-disposition: inline
X-Source-IP: 209.85.208.51
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10668
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=93
 malwarescore=0 bulkscore=0 priorityscore=420 adultscore=0 lowpriorityscore=0
 mlxlogscore=999 suspectscore=0 impostorscore=0 phishscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304030047 domainage_hfrom=10095
Cc: linux-kernel@vger.kernel.org, lkp@intel.com, oe-kbuild-all@lists.linux.dev
Subject: [Ocfs2-devel] fs/ocfs2/super.c:1809 ocfs2_mount_volume() warn: missing
 error code 'status'
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
From: Dan Carpenter via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Dan Carpenter <error27@gmail.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Google-Smtp-Source:
 AKy350ZP2GmTKzJfZURtI7SagiwJP+b8fzs406ux0ufhxpKxxCQtp2+4OeEsV7HPVccTDB3uys5Luw==
X-ServerName: mail-ed1-f51.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 redirect=_spf.google.com
X-Spam: Clean
X-Proofpoint-GUID: JGlUA6ZxcsO--WphTl8DwDRPK-m9obcz
X-Proofpoint-ORIG-GUID: JGlUA6ZxcsO--WphTl8DwDRPK-m9obcz
Reporting-Meta:
 AAF13VuA+VI8dRDBltLtmfI9Eq2bfHdof+HQoCEFNSdgAJBG2kMOcD9+AZstBwYB
 GwS+qaqvyEK9adXD18nITNOO28lchEd/byX/2Te7PA6JTBcmcnEEJZlmxOZs2vqd
 7AO1KYBZ1qF7N6ryhbVJRO5AgDnj9laxrYLTd28AcEH50st4mIcRTM7DbyXHYV55
 PR2pFsys6i6USTR+2uuC4jL3cYkMP8A6YpscJI3VR/nXDPgoae5lZupeiweBEDHt
 M7KS7d3KhOzg6/2uOM8d+VHq3CYYzWEN6d0F8vDDUsQFKYR2oAThDPxl29S5Qnap
 2pmgDdXRa4JlJ9xydFGc/o4Bs1sT3jkBAktHBB7ommD+LtF7NBejKD7wUxLuceJA
 c/0hnwFN2FfHCvUJI3FqKhE3Kv5u3QGiPta8RYVH9/ZwEAWI7UVKQ4ozKgBPsxM+
 ndgK3sxrp/GEdFr79opHaaf64OO4ctNCc5ZXAZ6DmXm57IyIQzVPFwoR/RNmcKGK
 p/QCQc7hHU+Fc9+Lk9Bv3Se1YA8GRkRtB60dfjvmP+Zf

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   7b50567bdcad8925ca1e075feb7171c12015afd1
commit: 0737e01de9c411e4db87dcedf4a9789d41b1c5c1 ocfs2: ocfs2_mount_volume does cleanup job before return error
config: arm64-randconfig-m041-20230329 (https://download.01.org/0day-ci/archive/20230401/202304012244.gX4H4rBO-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 12.1.0

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <error27@gmail.com>
| Link: https://lore.kernel.org/r/202304012244.gX4H4rBO-lkp@intel.com/

smatch warnings:
fs/ocfs2/super.c:1809 ocfs2_mount_volume() warn: missing error code 'status'

vim +/status +1809 fs/ocfs2/super.c

ccd979bdbce9fb Mark Fasheh                 2005-12-15  1803  static int ocfs2_mount_volume(struct super_block *sb)
ccd979bdbce9fb Mark Fasheh                 2005-12-15  1804  {
ccd979bdbce9fb Mark Fasheh                 2005-12-15  1805  	int status = 0;
ccd979bdbce9fb Mark Fasheh                 2005-12-15  1806  	struct ocfs2_super *osb = OCFS2_SB(sb);
ccd979bdbce9fb Mark Fasheh                 2005-12-15  1807  
ccd979bdbce9fb Mark Fasheh                 2005-12-15  1808  	if (ocfs2_is_hard_readonly(osb))
0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29 @1809  		goto out;

Hard to tell if this should be an error path or not...  Canonical
problem with do nothing gotos.

ccd979bdbce9fb Mark Fasheh                 2005-12-15  1810  
5500ab4ed3b8f0 Gang He                     2019-03-05  1811  	mutex_init(&osb->obs_trim_fs_mutex);
5500ab4ed3b8f0 Gang He                     2019-03-05  1812  
ccd979bdbce9fb Mark Fasheh                 2005-12-15  1813  	status = ocfs2_dlm_init(osb);
ccd979bdbce9fb Mark Fasheh                 2005-12-15  1814  	if (status < 0) {
ccd979bdbce9fb Mark Fasheh                 2005-12-15  1815  		mlog_errno(status);
a52370b3b182f7 Gang He                     2018-01-31  1816  		if (status == -EBADR && ocfs2_userspace_stack(osb))
a52370b3b182f7 Gang He                     2018-01-31  1817  			mlog(ML_ERROR, "couldn't mount because cluster name on"
a52370b3b182f7 Gang He                     2018-01-31  1818  			" disk does not match the running cluster name.\n");
0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1819  		goto out;
ccd979bdbce9fb Mark Fasheh                 2005-12-15  1820  	}
ccd979bdbce9fb Mark Fasheh                 2005-12-15  1821  
ccd979bdbce9fb Mark Fasheh                 2005-12-15  1822  	status = ocfs2_super_lock(osb, 1);
ccd979bdbce9fb Mark Fasheh                 2005-12-15  1823  	if (status < 0) {
ccd979bdbce9fb Mark Fasheh                 2005-12-15  1824  		mlog_errno(status);
0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1825  		goto out_dlm;
ccd979bdbce9fb Mark Fasheh                 2005-12-15  1826  	}
ccd979bdbce9fb Mark Fasheh                 2005-12-15  1827  
ccd979bdbce9fb Mark Fasheh                 2005-12-15  1828  	/* This will load up the node map and add ourselves to it. */
ccd979bdbce9fb Mark Fasheh                 2005-12-15  1829  	status = ocfs2_find_slot(osb);
ccd979bdbce9fb Mark Fasheh                 2005-12-15  1830  	if (status < 0) {
ccd979bdbce9fb Mark Fasheh                 2005-12-15  1831  		mlog_errno(status);
0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1832  		goto out_super_lock;
ccd979bdbce9fb Mark Fasheh                 2005-12-15  1833  	}
ccd979bdbce9fb Mark Fasheh                 2005-12-15  1834  
ccd979bdbce9fb Mark Fasheh                 2005-12-15  1835  	/* load all node-local system inodes */
ccd979bdbce9fb Mark Fasheh                 2005-12-15  1836  	status = ocfs2_init_local_system_inodes(osb);
ccd979bdbce9fb Mark Fasheh                 2005-12-15  1837  	if (status < 0) {
ccd979bdbce9fb Mark Fasheh                 2005-12-15  1838  		mlog_errno(status);
0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1839  		goto out_super_lock;
ccd979bdbce9fb Mark Fasheh                 2005-12-15  1840  	}
ccd979bdbce9fb Mark Fasheh                 2005-12-15  1841  
ccd979bdbce9fb Mark Fasheh                 2005-12-15  1842  	status = ocfs2_check_volume(osb);
ccd979bdbce9fb Mark Fasheh                 2005-12-15  1843  	if (status < 0) {
ccd979bdbce9fb Mark Fasheh                 2005-12-15  1844  		mlog_errno(status);
0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1845  		goto out_system_inodes;
ccd979bdbce9fb Mark Fasheh                 2005-12-15  1846  	}
ccd979bdbce9fb Mark Fasheh                 2005-12-15  1847  
ccd979bdbce9fb Mark Fasheh                 2005-12-15  1848  	status = ocfs2_truncate_log_init(osb);
0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1849  	if (status < 0) {
ccd979bdbce9fb Mark Fasheh                 2005-12-15  1850  		mlog_errno(status);
0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1851  		goto out_system_inodes;
0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1852  	}
c271c5c22b0a7c Sunil Mushran               2006-12-05  1853  
ccd979bdbce9fb Mark Fasheh                 2005-12-15  1854  	ocfs2_super_unlock(osb, 1);
0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1855  	return 0;
ccd979bdbce9fb Mark Fasheh                 2005-12-15  1856  
0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1857  out_system_inodes:
0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1858  	if (osb->local_alloc_state == OCFS2_LA_ENABLED)
0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1859  		ocfs2_shutdown_local_alloc(osb);
0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1860  	ocfs2_release_system_inodes(osb);
0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1861  	/* before journal shutdown, we should release slot_info */
0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1862  	ocfs2_free_slot_info(osb);
0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1863  	ocfs2_journal_shutdown(osb);
0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1864  out_super_lock:
0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1865  	ocfs2_super_unlock(osb, 1);
0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1866  out_dlm:
0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1867  	ocfs2_dlm_shutdown(osb, 0);
0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1868  out:
ccd979bdbce9fb Mark Fasheh                 2005-12-15  1869  	return status;
ccd979bdbce9fb Mark Fasheh                 2005-12-15  1870  }

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
