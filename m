Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C427BC761A6
	for <ocfs2-devel@archiver.kernel.org>; Mon,  3 Apr 2023 11:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=2c4IPcSh4uD6r1CJl5xEXY75i9gvKmxqhXkouhQcaEU=;
 b=sWNFrJayW9fgBhdzchj8gqR03FRKjl1o2Cz3sfviGvNVkW5QdDZma06QK/+e3jjwP7xvOPLmqs6v
   WMNYfoK5KjFjH4hAiQjIFkzbJgOCKAjNKTGPSAsohentuKkN4BtzRCwz67MUdjBpn49xp81ujqCm
   KQK/NK/e72vrGuKkdRSZ7emhpyf/vvBlcIGE5zOZHhIF/mCN48QIpmv9QJG+E6nx7mJ6zORUUDgj
   BnRVgt4Ap0VBGEDidBFfDRo+xh1hHP+4uuyiXKTEHBO6xiWui5FHKCelUDMnO1nRMmFtjHh2sSOL
   3yqDlMT2vfaRBp5+SL7e1Qlz1wV+MpJ3mS/Xfw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=2c4IPcSh4uD6r1CJl5xEXY75i9gvKmxqhXkouhQcaEU=;
 b=U68bZpWKfqMhbGkqKg+kPtJ3kqZNO4y8T+EfShpd3iYdtcyvAbDt4slliKzDESf5710Yye0nMpnq
   52gwHMDA/qU/SahDA8r6GfBRiFDXIoeHfOkj5KsWd8sgmZ0zajatXLvKy+Ofv16zo5ogGJYMhmuY
   omCzIUgfKTGjFR9XDNY0CWI8KQrXk3q5gPfqJC08stBm+qpxKmvwgKutsOZkdKMp4uVHJHTlUhfP
   1A+LXk0Qcp16ZP3LsEY3iWUvonOpr1v+skcZ0om38hWJa824xswJ6CqYBohH+LvW6O798MXDOsbv
   WN1u1AQBHuoniwsn29QAD1shFxjhgHZ0XeTLuA==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230317 64bit (built Mar 17
 2023))
 with ESMTPS id <0RSJ00O9FDLAWWA0@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 03 Apr 2023 11:07:58 +0000 (GMT)
Message-id: <4154b815-3be4-53de-1bc0-ca87ecb925a4@linux.alibaba.com>
Date: Mon, 3 Apr 2023 19:07:37 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
To: Dan Carpenter <error27@gmail.com>, oe-kbuild@lists.linux.dev,
 Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
References: <9e1d6835-34fc-49cd-869e-d99d9b546d17@kili.mountain>
Content-language: en-US
In-reply-to: <9e1d6835-34fc-49cd-869e-d99d9b546d17@kili.mountain>
X-Source-IP: 115.124.30.119
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10668
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxlogscore=999
 impostorscore=0 adultscore=0 phishscore=0 priorityscore=100 suspectscore=0
 lowpriorityscore=0 clxscore=103 spamscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304030084 domainage_hfrom=8754
Cc: linux-kernel@vger.kernel.org, lkp@intel.com, oe-kbuild-all@lists.linux.dev
Subject: Re: [Ocfs2-devel] fs/ocfs2/super.c:1809 ocfs2_mount_volume() warn:
 missing error code 'status'
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
From: Joseph Qi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Joseph Qi <joseph.qi@linux.alibaba.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R181e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018045168;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=7; SR=0;
 TI=SMTPD_---0VfHm6-7_1680520058;
X-ServerName: out30-119.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: r9ksHXxudSxV4menVmA3VAiUql_UUMC1
X-Proofpoint-GUID: r9ksHXxudSxV4menVmA3VAiUql_UUMC1
Reporting-Meta:
 AAFpjHRPxHpaFJMqO9xH1Q9FnchsjVc0ZlPd+1X60zIemISV9KYD3wYXukmJ29hC
 ssJ8NazYzcdSgFoZQN+4bJhzCdO3yzorrPRNJJmY3lJKdF0cyE1FkUm6bx8kIBrW
 /cAF36Dp8gHCWql2EuNl0NURrQSFnFkcdh8IptuDIPzbPuBYU9YD/hzmUhwbtrZa
 n0DaDInIMPjHv4M8TCOOLk6GKGCu5K2zIP5BQ8GO4Wn5fM6FGDze39Gte5awgYHB
 Yvp/DIPoy6EOA6NCOJA3hFEyceRQh7bY2rKTKNQrHLs4sJWgHyn6h/o0N47v+Nv5
 VuBjMT5BvItyfkxMVMHbxB96tYyiWw2GhWaMtwQFr9/tFzcn+CH2iZkFotnlp/B0
 C9M+BibybG7O1KAjW/glT8yH0ZpD3D2gWEfHR6UELPvrwqrOpJ7tBBdxE1CaMBf7
 1vVGB5TozNyfZPCP1Tpg/4LsgumYFXYC2Si2DPR2VanWxesJJCXh/wZxPrRtJFpM
 t85c8Q5elz7eYOkEjkuxUSJGYrx5hCJZD/ehnZK+wre3Pw==

Hi,
IIRC, we've discussed this before.
Success return is expected in case of 'hard readonly'.
So this a false positive report.

Thanks,
Joseph

On 4/3/23 2:14 PM, Dan Carpenter wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   7b50567bdcad8925ca1e075feb7171c12015afd1
> commit: 0737e01de9c411e4db87dcedf4a9789d41b1c5c1 ocfs2: ocfs2_mount_volume does cleanup job before return error
> config: arm64-randconfig-m041-20230329 (https://download.01.org/0day-ci/archive/20230401/202304012244.gX4H4rBO-lkp@intel.com/config)
> compiler: aarch64-linux-gcc (GCC) 12.1.0
> 
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
> | Reported-by: Dan Carpenter <error27@gmail.com>
> | Link: https://lore.kernel.org/r/202304012244.gX4H4rBO-lkp@intel.com/
> 
> smatch warnings:
> fs/ocfs2/super.c:1809 ocfs2_mount_volume() warn: missing error code 'status'
> 
> vim +/status +1809 fs/ocfs2/super.c
> 
> ccd979bdbce9fb Mark Fasheh                 2005-12-15  1803  static int ocfs2_mount_volume(struct super_block *sb)
> ccd979bdbce9fb Mark Fasheh                 2005-12-15  1804  {
> ccd979bdbce9fb Mark Fasheh                 2005-12-15  1805  	int status = 0;
> ccd979bdbce9fb Mark Fasheh                 2005-12-15  1806  	struct ocfs2_super *osb = OCFS2_SB(sb);
> ccd979bdbce9fb Mark Fasheh                 2005-12-15  1807  
> ccd979bdbce9fb Mark Fasheh                 2005-12-15  1808  	if (ocfs2_is_hard_readonly(osb))
> 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29 @1809  		goto out;
> 
> Hard to tell if this should be an error path or not...  Canonical
> problem with do nothing gotos.
> 
> ccd979bdbce9fb Mark Fasheh                 2005-12-15  1810  
> 5500ab4ed3b8f0 Gang He                     2019-03-05  1811  	mutex_init(&osb->obs_trim_fs_mutex);
> 5500ab4ed3b8f0 Gang He                     2019-03-05  1812  
> ccd979bdbce9fb Mark Fasheh                 2005-12-15  1813  	status = ocfs2_dlm_init(osb);
> ccd979bdbce9fb Mark Fasheh                 2005-12-15  1814  	if (status < 0) {
> ccd979bdbce9fb Mark Fasheh                 2005-12-15  1815  		mlog_errno(status);
> a52370b3b182f7 Gang He                     2018-01-31  1816  		if (status == -EBADR && ocfs2_userspace_stack(osb))
> a52370b3b182f7 Gang He                     2018-01-31  1817  			mlog(ML_ERROR, "couldn't mount because cluster name on"
> a52370b3b182f7 Gang He                     2018-01-31  1818  			" disk does not match the running cluster name.\n");
> 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1819  		goto out;
> ccd979bdbce9fb Mark Fasheh                 2005-12-15  1820  	}
> ccd979bdbce9fb Mark Fasheh                 2005-12-15  1821  
> ccd979bdbce9fb Mark Fasheh                 2005-12-15  1822  	status = ocfs2_super_lock(osb, 1);
> ccd979bdbce9fb Mark Fasheh                 2005-12-15  1823  	if (status < 0) {
> ccd979bdbce9fb Mark Fasheh                 2005-12-15  1824  		mlog_errno(status);
> 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1825  		goto out_dlm;
> ccd979bdbce9fb Mark Fasheh                 2005-12-15  1826  	}
> ccd979bdbce9fb Mark Fasheh                 2005-12-15  1827  
> ccd979bdbce9fb Mark Fasheh                 2005-12-15  1828  	/* This will load up the node map and add ourselves to it. */
> ccd979bdbce9fb Mark Fasheh                 2005-12-15  1829  	status = ocfs2_find_slot(osb);
> ccd979bdbce9fb Mark Fasheh                 2005-12-15  1830  	if (status < 0) {
> ccd979bdbce9fb Mark Fasheh                 2005-12-15  1831  		mlog_errno(status);
> 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1832  		goto out_super_lock;
> ccd979bdbce9fb Mark Fasheh                 2005-12-15  1833  	}
> ccd979bdbce9fb Mark Fasheh                 2005-12-15  1834  
> ccd979bdbce9fb Mark Fasheh                 2005-12-15  1835  	/* load all node-local system inodes */
> ccd979bdbce9fb Mark Fasheh                 2005-12-15  1836  	status = ocfs2_init_local_system_inodes(osb);
> ccd979bdbce9fb Mark Fasheh                 2005-12-15  1837  	if (status < 0) {
> ccd979bdbce9fb Mark Fasheh                 2005-12-15  1838  		mlog_errno(status);
> 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1839  		goto out_super_lock;
> ccd979bdbce9fb Mark Fasheh                 2005-12-15  1840  	}
> ccd979bdbce9fb Mark Fasheh                 2005-12-15  1841  
> ccd979bdbce9fb Mark Fasheh                 2005-12-15  1842  	status = ocfs2_check_volume(osb);
> ccd979bdbce9fb Mark Fasheh                 2005-12-15  1843  	if (status < 0) {
> ccd979bdbce9fb Mark Fasheh                 2005-12-15  1844  		mlog_errno(status);
> 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1845  		goto out_system_inodes;
> ccd979bdbce9fb Mark Fasheh                 2005-12-15  1846  	}
> ccd979bdbce9fb Mark Fasheh                 2005-12-15  1847  
> ccd979bdbce9fb Mark Fasheh                 2005-12-15  1848  	status = ocfs2_truncate_log_init(osb);
> 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1849  	if (status < 0) {
> ccd979bdbce9fb Mark Fasheh                 2005-12-15  1850  		mlog_errno(status);
> 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1851  		goto out_system_inodes;
> 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1852  	}
> c271c5c22b0a7c Sunil Mushran               2006-12-05  1853  
> ccd979bdbce9fb Mark Fasheh                 2005-12-15  1854  	ocfs2_super_unlock(osb, 1);
> 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1855  	return 0;
> ccd979bdbce9fb Mark Fasheh                 2005-12-15  1856  
> 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1857  out_system_inodes:
> 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1858  	if (osb->local_alloc_state == OCFS2_LA_ENABLED)
> 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1859  		ocfs2_shutdown_local_alloc(osb);
> 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1860  	ocfs2_release_system_inodes(osb);
> 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1861  	/* before journal shutdown, we should release slot_info */
> 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1862  	ocfs2_free_slot_info(osb);
> 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1863  	ocfs2_journal_shutdown(osb);
> 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1864  out_super_lock:
> 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1865  	ocfs2_super_unlock(osb, 1);
> 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1866  out_dlm:
> 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1867  	ocfs2_dlm_shutdown(osb, 0);
> 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1868  out:
> ccd979bdbce9fb Mark Fasheh                 2005-12-15  1869  	return status;
> ccd979bdbce9fb Mark Fasheh                 2005-12-15  1870  }
> 

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
