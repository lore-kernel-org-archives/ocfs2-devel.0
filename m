Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02153C761A6
	for <ocfs2-devel@archiver.kernel.org>; Mon,  3 Apr 2023 11:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=6nbFRG2O4Pl02u2x6kCtuOHzVpp+2cMIx48CvuhRX08=;
 b=nJ1Nu/MVkePKWO4Lauyu3EilnMTruYkpe7ycTRJ1CmfmAGMGk6Q/LyAWyJMl5wPBrihO/tDjZkiF
   IaBzlAMMMbwwRT2GAOy1N5FA5ZbpKFicDDZsoHNwUdXowE04x4/n/2jeycI1OE12JQNbSaRtDMNJ
   CHXi7pIJ9kvXMeJ9SzNd35cNl4sp0lj+au83+5uFB5xObbOL1BY/QWZFAg8IXcvYSfBIV9IsHkYW
   ZB/tQ6AiXICwUAinJr/gF6sT3ISOhkIM5nXMCkUIHAoW8Xqm4quMX/H9B0pXo+1dxBJ6GLWUfoqh
   2IN0D90xN1MdXDfbFX+HzpU1+k4ZTl4yFrKzhQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=6nbFRG2O4Pl02u2x6kCtuOHzVpp+2cMIx48CvuhRX08=;
 b=Wxj0mWPEhQaM7z80GfrgUOVFe37S8lFd4n2BBmLKoHTivK7TLZwp2bjKCDSIrF0a/0FCPBrpWnB+
   8/avQZzD+uqxM1anaCc3UwlKYkAZrr+dodvOkz8geOMNEUOBYhjMNvi5Pk0n8m2xREYlMTgx1ohr
   b3hLTAhkhWiCWxWPTx1LsRAHrYPrvwmmc3wvneMAkM27zRnkmq69A6kYUG7nO4bDeqKphUD0jXCg
   m339Ouu2rVCMzOwGyT5R6rJ6SJk6lg3gpHd1WcrUkUtREKGhYFI8lskIYOldw4ZRah9zFhe519Ud
   uCZUz8juylPO1yTJK+/WKHL/HK2SKYU+MkU5Sw==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230317 64bit (built Mar 17
 2023))
 with ESMTPS id <0RSJ003J3E7HIQ70@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 03 Apr 2023 11:21:17 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 t=1680520861;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=pSGbPNvPB+JspcMZAM7knRh0d6tq6zqNpiPGf74AOAk=;
 b=GSRqITYHxQvX4a+vFTAh0mGJOK8s75BHXaBTK7FjohiEENwEwJqpv8RnAt+DKFC4B0
 PqYcfmzIduKRaEguCAIwu782Mn0U2Qmil6Rm2zwZiijMpb9zvKEBbzNeMQcS4KFhw/4B
 v4nDpR9kcOl1pRePVbJm5lXI4c5DcEFfZL/z0R0lxAwKwvDiEUw0ns31TeUfu+gtrVuM
 ZLrSCh/GlaGIt47LB3SCWmzqHaK+cn7Q76Eg8Oi1g09acL1Jd5j5ct71GBwbe3V0hi5P
 PpToOZeh7QkcVUK9z7gxx4fiXZ7k6gcEZ6scoKIwMfcuPibX6J4Cl+OpD/JcGZmj7T1U Lr9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20210112; t=1680520861;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to; bh=pSGbPNvPB+JspcMZAM7knRh0d6tq6zqNpiPGf74AOAk=;
 b=fMosL8ZEXZlVDz3MqXO8UIg9PFMHUBpDAJ4k3ff9BwD2K6UUdB1RhsjUQ0iZpG7edO
 p4DolBUY6DXfQBmU4aGDCaa/uwfWgMe2jwYxtPthGfwAC/nZB2B9X2Nf46UeuAatSJ97
 2bMY03/H+WNVhfzya1PNxtOBkX5BCmQSChOZ+LPmj9uRAerrFQKulPZHldRyR0dL+dpM
 NJRnEdLaWQbKXVrnzwwLCBl7Evq0nLegrW2MYMrUXQfIpiFqmSrE8ArgUrctbskOfDQL
 qo21pKKx/mWbsDCcQr+SOuPlKePre215oQRdjYaBb13aMIf1sirrgr/7U8xoBsBAZozo 1L8g==
X-Gm-Message-State: AAQBX9fxDbEkum136zeEBko4fD9sSSLQ4NryWGRiaWYGxcPslKWq1/WY
 yPYEOwPUN95N5LTmyEtqmkbJ97xpa/5I2pxz
X-Received: by 2002:a17:906:1cc5:b0:931:42d2:a77f with SMTP id
 i5-20020a1709061cc500b0093142d2a77fmr34597474ejh.15.1680520860851; Mon,
 03 Apr 2023 04:21:00 -0700 (PDT)
Date: Mon, 3 Apr 2023 14:20:55 +0300
To: Joseph Qi <joseph.qi@linux.alibaba.com>, lkp@intel.com,
 oe-kbuild-all@lists.linux.dev
Message-id: <1e7d7076-ddd6-41b3-b824-673986c35477@kili.mountain>
References: <9e1d6835-34fc-49cd-869e-d99d9b546d17@kili.mountain>
 <4154b815-3be4-53de-1bc0-ca87ecb925a4@linux.alibaba.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <4154b815-3be4-53de-1bc0-ca87ecb925a4@linux.alibaba.com>
X-Source-IP: 209.85.208.41
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10668
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=481 lowpriorityscore=0 phishscore=0 impostorscore=0 bulkscore=0
 clxscore=112 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 adultscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304030085 domainage_hfrom=10095
Cc: oe-kbuild@lists.linux.dev,
 Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>,
 linux-kernel@vger.kernel.org
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
From: Dan Carpenter via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Dan Carpenter <error27@gmail.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Google-Smtp-Source:
 AKy350Y758ypGm4nbge2JI3sswU+UqJX9IukkLLnBaBtKLA2khnktn53Px0p8a/quttJT+79zP8qbg==
X-ServerName: mail-ed1-f41.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 redirect=_spf.google.com
X-Spam: Clean
X-Proofpoint-GUID: tCIPLUq-6Mk-VF9sCIx96WPgkvLIWF3R
X-Proofpoint-ORIG-GUID: tCIPLUq-6Mk-VF9sCIx96WPgkvLIWF3R
Reporting-Meta:
 AAGgxibqEkOiUFd+3gkC8ETct1luxJduNup4xrcL8mknbQcy7jn+ipNmh94uvdBJ
 GAksGvfJP6gZ0bT83eQgvy3LqekmJMQGqnO/2WTvIZJvwmeLpSkZyXvz5DwHVBVA
 9wwwJ7F/phNtrUBcqYcjX/hLg7MFSgoZnJhHlVU4o6SCubI08GQS3HXIQx1aVc3T
 haJ7Lc4kDUFjkMTmz5gwJJ9lH9Gg3UjUQ14LcwNpIZAWFO4hkkur1UC3L1Kqmo0Z
 vrVjeG1V8hngkEa+2I6G3IZ0LV5fKxBZi0SoUdsfohtg08qjNyRTfFLJ6GSHQfIN
 SJmSxqadzxW1D0vONpXJwUWypMuWMg59JwqWgIa0eXMsbiYOZKUqfuuVo3bKEAzR
 bfe0TJxmK0+r7RBh3fW4nFVPPwYq4u60EuqcZI7/9c1lfR7xwdAPa0h61dAqMC8f
 HagVFgssMFZ0H61hcexKMC6PXjZedFkg8t79Hmcg67GlO+cy2bmLE3u4Q9sCpPYH
 rxKoUe5uktZYxhgsu5G416xOqUF9RmlZ90M5mOu2ZryX

Sorry, the kbuild bot is not supposed to send duplicate warnings.  I
don't know why it was sent again...

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   7b50567bdcad8925ca1e075feb7171c12015afd1
commit: 0737e01de9c411e4db87dcedf4a9789d41b1c5c1 ocfs2: ocfs2_mount_volume does cleanup job before return error
date:   11 months ago
:::::: branch date: 15 hours ago
       ^^^^^^^^^^^^^^^^^^^^^^^^^
Something happened on Apr 1.

:::::: commit date: 11 months ago
config: arm64-randconfig-m041-20230329 (https://download.01.org/0day-ci/archive/20230401/202304012244.gX4H4rBO-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 12.1.0

regards,
dan carpenter

On Mon, Apr 03, 2023 at 07:07:37PM +0800, Joseph Qi wrote:
> Hi,
> IIRC, we've discussed this before.
> Success return is expected in case of 'hard readonly'.
> So this a false positive report.
> 
> Thanks,
> Joseph
> 
> On 4/3/23 2:14 PM, Dan Carpenter wrote:
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> > head:   7b50567bdcad8925ca1e075feb7171c12015afd1
> > commit: 0737e01de9c411e4db87dcedf4a9789d41b1c5c1 ocfs2: ocfs2_mount_volume does cleanup job before return error
> > config: arm64-randconfig-m041-20230329 (https://download.01.org/0day-ci/archive/20230401/202304012244.gX4H4rBO-lkp@intel.com/config)
> > compiler: aarch64-linux-gcc (GCC) 12.1.0
> > 
> > If you fix the issue, kindly add following tag where applicable
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Reported-by: Dan Carpenter <error27@gmail.com>
> > | Link: https://lore.kernel.org/r/202304012244.gX4H4rBO-lkp@intel.com/
> > 
> > smatch warnings:
> > fs/ocfs2/super.c:1809 ocfs2_mount_volume() warn: missing error code 'status'
> > 
> > vim +/status +1809 fs/ocfs2/super.c
> > 
> > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1803  static int ocfs2_mount_volume(struct super_block *sb)
> > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1804  {
> > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1805  	int status = 0;
> > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1806  	struct ocfs2_super *osb = OCFS2_SB(sb);
> > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1807  
> > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1808  	if (ocfs2_is_hard_readonly(osb))
> > 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29 @1809  		goto out;
> > 
> > Hard to tell if this should be an error path or not...  Canonical
> > problem with do nothing gotos.
> > 
> > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1810  
> > 5500ab4ed3b8f0 Gang He                     2019-03-05  1811  	mutex_init(&osb->obs_trim_fs_mutex);
> > 5500ab4ed3b8f0 Gang He                     2019-03-05  1812  
> > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1813  	status = ocfs2_dlm_init(osb);
> > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1814  	if (status < 0) {
> > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1815  		mlog_errno(status);
> > a52370b3b182f7 Gang He                     2018-01-31  1816  		if (status == -EBADR && ocfs2_userspace_stack(osb))
> > a52370b3b182f7 Gang He                     2018-01-31  1817  			mlog(ML_ERROR, "couldn't mount because cluster name on"
> > a52370b3b182f7 Gang He                     2018-01-31  1818  			" disk does not match the running cluster name.\n");
> > 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1819  		goto out;
> > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1820  	}
> > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1821  
> > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1822  	status = ocfs2_super_lock(osb, 1);
> > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1823  	if (status < 0) {
> > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1824  		mlog_errno(status);
> > 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1825  		goto out_dlm;
> > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1826  	}
> > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1827  
> > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1828  	/* This will load up the node map and add ourselves to it. */
> > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1829  	status = ocfs2_find_slot(osb);
> > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1830  	if (status < 0) {
> > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1831  		mlog_errno(status);
> > 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1832  		goto out_super_lock;
> > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1833  	}
> > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1834  
> > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1835  	/* load all node-local system inodes */
> > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1836  	status = ocfs2_init_local_system_inodes(osb);
> > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1837  	if (status < 0) {
> > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1838  		mlog_errno(status);
> > 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1839  		goto out_super_lock;
> > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1840  	}
> > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1841  
> > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1842  	status = ocfs2_check_volume(osb);
> > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1843  	if (status < 0) {
> > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1844  		mlog_errno(status);
> > 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1845  		goto out_system_inodes;
> > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1846  	}
> > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1847  
> > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1848  	status = ocfs2_truncate_log_init(osb);
> > 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1849  	if (status < 0) {
> > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1850  		mlog_errno(status);
> > 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1851  		goto out_system_inodes;
> > 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1852  	}
> > c271c5c22b0a7c Sunil Mushran               2006-12-05  1853  
> > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1854  	ocfs2_super_unlock(osb, 1);
> > 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1855  	return 0;
> > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1856  
> > 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1857  out_system_inodes:
> > 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1858  	if (osb->local_alloc_state == OCFS2_LA_ENABLED)
> > 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1859  		ocfs2_shutdown_local_alloc(osb);
> > 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1860  	ocfs2_release_system_inodes(osb);
> > 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1861  	/* before journal shutdown, we should release slot_info */
> > 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1862  	ocfs2_free_slot_info(osb);
> > 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1863  	ocfs2_journal_shutdown(osb);
> > 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1864  out_super_lock:
> > 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1865  	ocfs2_super_unlock(osb, 1);
> > 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1866  out_dlm:
> > 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1867  	ocfs2_dlm_shutdown(osb, 0);
> > 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1868  out:
> > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1869  	return status;
> > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1870  }
> > 

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
