Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44E12C4332F
	for <ocfs2-devel@archiver.kernel.org>; Tue,  8 Nov 2022 16:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=3DxatIRLcfWmmyArR5vNu2X/4AKGjSLo26mCeYIv6Ic=;
 b=z+odZf+ffVaMFF0jfDEwHkrcKegffe7zijUBlrw5Du94muCkGNGJ9k/h8mqeJCQMiJ1Fy9cJ4vuZ
   ldwmmHfYCI/9JUVsOrwyTsRylp/ZNKOxS+XAEfImZ94W1/lHWxXqllkwOFxnGvY/t/xMslI9whlD
   A39bamvI6vC8mgzJG9+y8PV7SvxKa2JBQM1vt9Yc0EjnHbZviLzYokV+SzEWbb+VDuGnrTRq6vTs
   Tf5Uu0xIi42Wfw7sM+CKHam+5KQyuWHdlGOKwiPyD2iY0PiagsjbCE9b1BiaBiJxN2i6TH/anFsL
   odg+Sv5c+tXYXFtNhDrJMMW1XmR+vUA4qXHBqg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=3DxatIRLcfWmmyArR5vNu2X/4AKGjSLo26mCeYIv6Ic=;
 b=X+TAWnYCJ+kJQ3hCYnU4Vf0LldvX9a++DK0fwgRegXaBe+klQrEFslKGQqfDMo14cwiNeMfT2rdb
   EgUSWcsJvhfXkUf8dCsH1ebzAbtyZjaLyjN2LHalIi92eHGVZFMEHYxUdThmBELGStWPJULEborM
   05gBOiKHW59fkfI4O/FSE/815HL8cmPGIRA6cuocxcm13gkFE5ABC4aT92w102VXSK3I8r1lAILl
   Am2aul3S+QtJ/Rezq3eUBhAGVGlgLStKPaxDcZkbuu4GPascExC6b3zlyxVEsJrs8yVF5nX9gys+
   4DIhA7F/976sdrLRPRqCDsHv7CzvjsJGTGKRcQ==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221026 64bit (built Oct 26
 2022))
 with ESMTPS id <0RL10064HFF1HKE0@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 08 Nov 2022 16:35:25 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=content-disposition:mime-version:message-id:subject:cc:to:from:date
 :from:to:cc:subject:date:message-id:reply-to;
 bh=tP7byI0+Iy8thvBM9RxOZ1IAYRCUM1f3pZvYHntjIiU=;
 b=DOEVQebwcJYZ/5W4LsmNd5BxPP3oBR0tUoHQD+yVm7KtNQLdI33Kxpiyv6k1NPct3d
 TurVtwwBhEkn2mHX6TPae3EuT1hEMKdeiBcf88WBXTnIC577NYFCHOTGpLfIzv9UjqHz
 lKPbX/Lc8OMHGYc0Yp5Rwehx3aljErPfr9t21Mkn/V7wHwfa57zgGFAe+iye9YXky3Rd
 VHCv64i4uEGPsxNIn8Zzvp6VI/dDqGZZdUPeEWDFdDq3T3bIcPmavAhkFXfoqZgtw/a9
 3T4CVHiCkUbrSqtnin2DcXzehauiCY95qQP4m63W2/D+F7YuhW3Ae8RVQvkUW8dz6EG+ EKcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20210112;
 h=content-disposition:mime-version:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=tP7byI0+Iy8thvBM9RxOZ1IAYRCUM1f3pZvYHntjIiU=;
 b=s7PTjkBuJaYO/MBfybVJbvBWQzkz11QnnIxuLRVn1p0j9QIl1Kt9Pi6lLOf+SrNOOy
 d9+R8YJpwQCcnKgs/ZEg2FtOBeDe0IyOqWlp+KF2UoIW3UatB5okmanKHrDYLapgQa8F
 oK2A+xdqPrdybjZYPZA8zDNdG/kzWbKTiGeyWhze2lhYOj4oQk8ZWWmVe+QmNmdzyjgj
 4gIrpJBDAhd7HGgyUQHhAttSiIAWac46NGKAN90VGGV8TcSm8YvrOaVufTcoHji52mM/
 xX0ZnLoMHsv9Ik4gTPHrB2B6YMGxkvyXheyXMGzNAQIyGlYx63Um29JPwQjEP5XURTqt SqTQ==
X-Gm-Message-State: ACrzQf18Zr0wCKVkTPhc4hdNcykEIO1ajMZ9gY0oo6OmDcRhAGXGt8wy
 35ZIJ/xUywTRHVF8EjUnptU=
X-Received: by 2002:adf:f911:0:b0:21e:c0f6:fd26 with SMTP id
 b17-20020adff911000000b0021ec0f6fd26mr25119107wrr.361.1667646945769; Sat,
 05 Nov 2022 04:15:45 -0700 (PDT)
Date: Sat, 5 Nov 2022 14:15:40 +0300
To: oe-kbuild@lists.linux.dev,
 Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Message-id: <202211050722.8YGvtPaR-lkp@intel.com>
MIME-version: 1.0
Content-disposition: inline
X-Source-IP: 209.85.221.44
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10521
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 lowpriorityscore=0 impostorscore=0 malwarescore=0 suspectscore=0 spamscore=0
 mlxlogscore=937 clxscore=17 phishscore=0 bulkscore=0 adultscore=0
 priorityscore=330 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211050086 domainage_hfrom=9946
Cc: lkp@intel.com, linux-kernel@vger.kernel.org,
 Linux Memory Management List <linux-mm@kvack.org>,
 oe-kbuild-all@lists.linux.dev
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
 AMsMyM6WU7D2DZTLSdga05zuSpJl+2j2RYGDDpUBqWXo2H5qPh665HWr76c5oJV4AiBpWLaaf+cC9A==
X-ServerName: mail-wr1-f44.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 redirect=_spf.google.com
X-Spam: Clean
X-Proofpoint-ORIG-GUID: qe1k19DP5jiPLcBv8PBwAqpWv7zPMDtX
X-Proofpoint-GUID: qe1k19DP5jiPLcBv8PBwAqpWv7zPMDtX
X-Mailman-Approved-At: Tue, 08 Nov 2022 16:35:23 +0000
Reporting-Meta:
 AAFz9ciH2O8fxJb6/6ZHonbzYgGbzKlKqsK8zAU0ZM5010jN8Ti3RNM1jeRdG3eK
 D9UY9ahEPY5JrDPeydyod4rztbe6/SBVWE58q14jYfzlIT8lFmVfAqHBTHm9Do9k
 ErdnlXDkW8W7sFTQOmyPP+Xvm+9BojHAbw555vpx6duk/68USHkDBpwEniirr+rK
 AqUm8TdgwKu+TeDTD2q205unfxL5Ya3nk59rQB3Z4DEyiggd4DtaEnQFKxIAlfvv
 fl5kuhMM1RjKJs4hrbpIa13GW/AqHREA6o7LRtk5xZcM+L+xSy2zeHDp+f9/yQ6Z
 Rr2AelmoLq/rDBvwII3Z/wO6tD65n+BTCZ65rlzFj1VAyEXMP0i695MWn4iJy7vd
 a6maap0oqfah9/DtTteSnnI0SYEn4pjHlVg0zB/ZfAz3aaqbXTzz/lPg0YP0jrkh
 XBPDyv0kP6uJ5/v/uWClxt0KcEPAhI0BXzOt5VdX1NgaGTiY03MOt4HilAOifLm1
 PCuSKjuEWATjUQoL//FN7Krfs0vp49GBUBzfkhwH8DJv

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   10d916c86ecafeccaed89175ebf9b832dddde380
commit: 0737e01de9c411e4db87dcedf4a9789d41b1c5c1 ocfs2: ocfs2_mount_volume does cleanup job before return error
config: alpha-randconfig-m041-20221030
compiler: alpha-linux-gcc (GCC) 12.1.0

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <error27@gmail.com>

smatch warnings:
fs/ocfs2/super.c:1809 ocfs2_mount_volume() warn: missing error code 'status'

vim +/status +1809 fs/ocfs2/super.c

ccd979bdbce9fba Mark Fasheh                 2005-12-15  1802  
ccd979bdbce9fba Mark Fasheh                 2005-12-15  1803  static int ocfs2_mount_volume(struct super_block *sb)
ccd979bdbce9fba Mark Fasheh                 2005-12-15  1804  {
ccd979bdbce9fba Mark Fasheh                 2005-12-15  1805  	int status = 0;
ccd979bdbce9fba Mark Fasheh                 2005-12-15  1806  	struct ocfs2_super *osb = OCFS2_SB(sb);
ccd979bdbce9fba Mark Fasheh                 2005-12-15  1807  
ccd979bdbce9fba Mark Fasheh                 2005-12-15  1808  	if (ocfs2_is_hard_readonly(osb))
0737e01de9c411e Heming Zhao via Ocfs2-devel 2022-04-29 @1809  		goto out;

Unclear if this is an error path or a success path.  Honestly, I would
have thought the checker is correct that it looks like a failure path.

ccd979bdbce9fba Mark Fasheh                 2005-12-15  1810  
5500ab4ed3b8f07 Gang He                     2019-03-05  1811  	mutex_init(&osb->obs_trim_fs_mutex);
5500ab4ed3b8f07 Gang He                     2019-03-05  1812  
ccd979bdbce9fba Mark Fasheh                 2005-12-15  1813  	status = ocfs2_dlm_init(osb);
ccd979bdbce9fba Mark Fasheh                 2005-12-15  1814  	if (status < 0) {
ccd979bdbce9fba Mark Fasheh                 2005-12-15  1815  		mlog_errno(status);
a52370b3b182f79 Gang He                     2018-01-31  1816  		if (status == -EBADR && ocfs2_userspace_stack(osb))
a52370b3b182f79 Gang He                     2018-01-31  1817  			mlog(ML_ERROR, "couldn't mount because cluster name on"
a52370b3b182f79 Gang He                     2018-01-31  1818  			" disk does not match the running cluster name.\n");
0737e01de9c411e Heming Zhao via Ocfs2-devel 2022-04-29  1819  		goto out;
ccd979bdbce9fba Mark Fasheh                 2005-12-15  1820  	}
ccd979bdbce9fba Mark Fasheh                 2005-12-15  1821  
ccd979bdbce9fba Mark Fasheh                 2005-12-15  1822  	status = ocfs2_super_lock(osb, 1);
ccd979bdbce9fba Mark Fasheh                 2005-12-15  1823  	if (status < 0) {
ccd979bdbce9fba Mark Fasheh                 2005-12-15  1824  		mlog_errno(status);
0737e01de9c411e Heming Zhao via Ocfs2-devel 2022-04-29  1825  		goto out_dlm;
ccd979bdbce9fba Mark Fasheh                 2005-12-15  1826  	}
ccd979bdbce9fba Mark Fasheh                 2005-12-15  1827  
ccd979bdbce9fba Mark Fasheh                 2005-12-15  1828  	/* This will load up the node map and add ourselves to it. */
ccd979bdbce9fba Mark Fasheh                 2005-12-15  1829  	status = ocfs2_find_slot(osb);
ccd979bdbce9fba Mark Fasheh                 2005-12-15  1830  	if (status < 0) {
ccd979bdbce9fba Mark Fasheh                 2005-12-15  1831  		mlog_errno(status);
0737e01de9c411e Heming Zhao via Ocfs2-devel 2022-04-29  1832  		goto out_super_lock;
ccd979bdbce9fba Mark Fasheh                 2005-12-15  1833  	}
ccd979bdbce9fba Mark Fasheh                 2005-12-15  1834  
ccd979bdbce9fba Mark Fasheh                 2005-12-15  1835  	/* load all node-local system inodes */
ccd979bdbce9fba Mark Fasheh                 2005-12-15  1836  	status = ocfs2_init_local_system_inodes(osb);
ccd979bdbce9fba Mark Fasheh                 2005-12-15  1837  	if (status < 0) {
ccd979bdbce9fba Mark Fasheh                 2005-12-15  1838  		mlog_errno(status);
0737e01de9c411e Heming Zhao via Ocfs2-devel 2022-04-29  1839  		goto out_super_lock;
ccd979bdbce9fba Mark Fasheh                 2005-12-15  1840  	}
ccd979bdbce9fba Mark Fasheh                 2005-12-15  1841  
ccd979bdbce9fba Mark Fasheh                 2005-12-15  1842  	status = ocfs2_check_volume(osb);
ccd979bdbce9fba Mark Fasheh                 2005-12-15  1843  	if (status < 0) {
ccd979bdbce9fba Mark Fasheh                 2005-12-15  1844  		mlog_errno(status);
0737e01de9c411e Heming Zhao via Ocfs2-devel 2022-04-29  1845  		goto out_system_inodes;
ccd979bdbce9fba Mark Fasheh                 2005-12-15  1846  	}
ccd979bdbce9fba Mark Fasheh                 2005-12-15  1847  
ccd979bdbce9fba Mark Fasheh                 2005-12-15  1848  	status = ocfs2_truncate_log_init(osb);
0737e01de9c411e Heming Zhao via Ocfs2-devel 2022-04-29  1849  	if (status < 0) {
ccd979bdbce9fba Mark Fasheh                 2005-12-15  1850  		mlog_errno(status);
0737e01de9c411e Heming Zhao via Ocfs2-devel 2022-04-29  1851  		goto out_system_inodes;
0737e01de9c411e Heming Zhao via Ocfs2-devel 2022-04-29  1852  	}
c271c5c22b0a7ca Sunil Mushran               2006-12-05  1853  
ccd979bdbce9fba Mark Fasheh                 2005-12-15  1854  	ocfs2_super_unlock(osb, 1);
0737e01de9c411e Heming Zhao via Ocfs2-devel 2022-04-29  1855  	return 0;
ccd979bdbce9fba Mark Fasheh                 2005-12-15  1856  
0737e01de9c411e Heming Zhao via Ocfs2-devel 2022-04-29  1857  out_system_inodes:
0737e01de9c411e Heming Zhao via Ocfs2-devel 2022-04-29  1858  	if (osb->local_alloc_state == OCFS2_LA_ENABLED)
0737e01de9c411e Heming Zhao via Ocfs2-devel 2022-04-29  1859  		ocfs2_shutdown_local_alloc(osb);
0737e01de9c411e Heming Zhao via Ocfs2-devel 2022-04-29  1860  	ocfs2_release_system_inodes(osb);
0737e01de9c411e Heming Zhao via Ocfs2-devel 2022-04-29  1861  	/* before journal shutdown, we should release slot_info */
0737e01de9c411e Heming Zhao via Ocfs2-devel 2022-04-29  1862  	ocfs2_free_slot_info(osb);
0737e01de9c411e Heming Zhao via Ocfs2-devel 2022-04-29  1863  	ocfs2_journal_shutdown(osb);
0737e01de9c411e Heming Zhao via Ocfs2-devel 2022-04-29  1864  out_super_lock:
0737e01de9c411e Heming Zhao via Ocfs2-devel 2022-04-29  1865  	ocfs2_super_unlock(osb, 1);
0737e01de9c411e Heming Zhao via Ocfs2-devel 2022-04-29  1866  out_dlm:
0737e01de9c411e Heming Zhao via Ocfs2-devel 2022-04-29  1867  	ocfs2_dlm_shutdown(osb, 0);
0737e01de9c411e Heming Zhao via Ocfs2-devel 2022-04-29  1868  out:
ccd979bdbce9fba Mark Fasheh                 2005-12-15  1869  	return status;
ccd979bdbce9fba Mark Fasheh                 2005-12-15  1870  }

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
