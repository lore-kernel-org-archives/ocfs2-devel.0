Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DEDFC43219
	for <ocfs2-devel@archiver.kernel.org>; Tue,  8 Nov 2022 16:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=kXXnYIBXAAvTPBH1u15+fISt+E4COx9H2ceEclELQY8=;
 b=xKu5AXttTszimQ6blWX6iNtMjN6xzpGia/pK53K8jaCJ3NHv2GO1G5R4fT7TC6J83vTzmklgz+YO
   BgkAdMorKKrO5sO45R7l3Uz1bRtXZkL9uxMFAM/pEvDwucYLH+KylIWqOuDqMGIxkNeiQ8Z8SRjW
   wNFZ6WqIe9v6IZsPTqHQzxH6qexPlpDwyLZwPIadYi5HTpsQaYlMvqJmXwzCpmPwY4xCGynaNYao
   F9AuxYt5xru3iftI0gkQA/8eeq0SrffW3n78OYHLbW4ehUJS6/H4zFkL54AZKfXcE3SlBb7lhaty
   7EGmvTlraNUu/nywjjlPWJ8o5LqMTCztxJnCPg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=kXXnYIBXAAvTPBH1u15+fISt+E4COx9H2ceEclELQY8=;
 b=eEgXm7FJ2qxD6y/+23lwZzHBiE74u0buYJZjr/Wg0efFVgetJCiDmaSf8lo+42DMGdWs/uy63Kqv
   i49sPa+LY60AQJAYliJbN70MfDgOLDmISN0A4aZ10rbHSVDxFSElJNpJG7i32DUw0+cfDtQZe56g
   1vnk0INGum57WLfz5gYRfn/wpkpNfCn19s2xSViUJbyN8lnJ7Wnw0TGDrdVoPUV5TRGc20bv43/7
   6Ls6NZZjlMZrfXZEjA9oelTBJ0LmsbO5TJS7WPZXGkkVV2SyG5cvhhRBJZXCXmSvo9emu1vthUpM
   dXqh0wH+QMsozewj/pRP+AMWaP5i9hRfbURAPw==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221026 64bit (built Oct 26
 2022))
 with ESMTPS id <0RL100J9BFF1QZ30@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 08 Nov 2022 16:35:25 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=1EXtR7XJJXiRjK9vYVDqObq6bajFz9XQCg+T26fuKrE=;
 b=AhyPTp2hdxp66jkLu7AniU2AycEFO8kjoA0cTSA2DXMhMakoLktz1BMuwuFBMRoX/L
 iqDcuROIWNrO1ABA1AvPsmmiAQPwvxmCMQF7aNE4VlzVKkbOO1EbgDA6C9m0e1+yann8
 KLNkWVfXds2T/RExpxkwWdWVZM8unzDG437HCPvEiRRHo37+80ifBWPnoaTJV4KVMywv
 AqXyf0MOPklW9RRMqSQvW0Z4wGOHY2DurTzEqyRxSCGagg4TRN+FeNOjsMKqS3V3UiGI
 Ua/VAiTmsxsndtlxlQIdq1zjsdpinmbjos/47b59qPYe+SFpVtfCi0X8Z8MSfMDlD9nH VM8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to; bh=1EXtR7XJJXiRjK9vYVDqObq6bajFz9XQCg+T26fuKrE=;
 b=iA32dZnt5URtMJ4IxUmtcgMZZ1eVDs7Ibza6HbhJKYUU5pD2koWXx2/YdatA/rI03n
 9HRPe0OdnuunR3OQGnwmS64CCa0cWlow2cI2mtKBF5JJXVIlSjs3XFR6iahTLdyts54D
 DgbPOj0EU4EyHGQejcxRXx5fxqPEn8GU80bH1eVgoWyHlbbCIfPF7R+xw9ynQt0135de
 9/v+w0+coEFoCc8iEfNbsPWfgTyx9uS6ZVpnuVFJKIcIdqtLDT5QX+7l3h/eIDKFbG2T
 2VzlxQNW2O4zsTmFTjDw1bu1y4dfHl4UsPufsTQ2/EjBL1FbedA2PqT1aDGc76PFlNAs WliA==
X-Gm-Message-State: ANoB5pkiJjecSM0odlY3f3FhTpj4XzouhHdtNH+r/uZm9Aqtc53KKhIz
 dIL0ap2TLl2ITm4rtW6SN4c=
X-Received: by 2002:a05:600c:1906:b0:3cf:a851:d2b1 with SMTP id
 j6-20020a05600c190600b003cfa851d2b1mr3825762wmq.18.1667807578922; Sun,
 06 Nov 2022 23:52:58 -0800 (PST)
Date: Mon, 7 Nov 2022 10:52:55 +0300
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-id: <Y2i5V0CIH2tOCMUs@kadam>
References: <202211050722.8YGvtPaR-lkp@intel.com>
 <97361840-0a56-f074-0495-712dafe4313d@linux.alibaba.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <97361840-0a56-f074-0495-712dafe4313d@linux.alibaba.com>
X-Source-IP: 209.85.128.51
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10523
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 adultscore=0 spamscore=0 lowpriorityscore=0 suspectscore=0 priorityscore=421
 mlxlogscore=970 phishscore=0 clxscore=113 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211070066 domainage_hfrom=9948
Cc: oe-kbuild@lists.linux.dev, linux-kernel@vger.kernel.org,
 Linux Memory Management List <linux-mm@kvack.org>,
 oe-kbuild-all@lists.linux.dev,
 Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>, lkp@intel.com
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
 AA0mqf6U/0XYoOBRltwbquuygrt1XbVmjosVnlfe1s1uJGbaRhSF/xTmhGk6btHBRVs32l434UvZhA==
X-ServerName: mail-wm1-f51.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 redirect=_spf.google.com
X-Spam: Clean
X-Proofpoint-ORIG-GUID: ZE4qq9YxisrEELnQG65x-E0pfPNflv2r
X-Proofpoint-GUID: ZE4qq9YxisrEELnQG65x-E0pfPNflv2r
X-Mailman-Approved-At: Tue, 08 Nov 2022 16:35:23 +0000
Reporting-Meta:
 AAFa9lamjXFxRtlTAVQknzpUdoCST2b05ZKFchRXwOUMAtx3X/ZRVnRHBhELbGNY
 3LeKDh3YagNiygYY+cjfaJqjvBFdgakjLnPMQD0upHKpaKAwgAVbXkAqIUixgJ75
 Fh5h4gYnpUR5WSM4G5IJ9Z2oA/1lYdo65mD+5LeTqPZdgtn32+TFsXxQABHpy3gy
 ABuE5h2LhiAdwzwxa1PMKbgvsWCAWZy2U0PLQaS8+Uxd6TsfQBII59KiSxQhrIxt
 c0H6wjTzZmdYdSc3zSTKZfz0HStOXpW/LBXOolMG5V4bBjuIr+ssGvfwize7vETs
 tJtClE3LKPQjjRejhkBo8o9vMvKwiLx5irK+C0yD6Z0EgCx1KaW+JMMyN26aZX/s
 Rvh+shi5tLhFZm+d9QC8ZzvghnUSab1NIYC9pCpzvUYUnagZMvB48xOAmm8gx8hc
 QJploAqV8aKlnVxl4rdPR6M++LVT8BRE5BdgxkrqxOwt5SuLcHTPo4toREjnF47J
 +SzRVyoXe2tXUOwYG2TKlAZZ5dkp+FInnVS3YonqALk=

On Sun, Nov 06, 2022 at 08:38:07PM +0800, Joseph Qi wrote:
> 
> 
> On 11/5/22 7:15 PM, Dan Carpenter wrote:
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> > head:   10d916c86ecafeccaed89175ebf9b832dddde380
> > commit: 0737e01de9c411e4db87dcedf4a9789d41b1c5c1 ocfs2: ocfs2_mount_volume does cleanup job before return error
> > config: alpha-randconfig-m041-20221030
> > compiler: alpha-linux-gcc (GCC) 12.1.0
> > 
> > If you fix the issue, kindly add following tag where applicable
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Reported-by: Dan Carpenter <error27@gmail.com>
> > 
> > smatch warnings:
> > fs/ocfs2/super.c:1809 ocfs2_mount_volume() warn: missing error code 'status'
> > 
> > vim +/status +1809 fs/ocfs2/super.c
> > 
> > ccd979bdbce9fba Mark Fasheh                 2005-12-15  1802  
> > ccd979bdbce9fba Mark Fasheh                 2005-12-15  1803  static int ocfs2_mount_volume(struct super_block *sb)
> > ccd979bdbce9fba Mark Fasheh                 2005-12-15  1804  {
> > ccd979bdbce9fba Mark Fasheh                 2005-12-15  1805  	int status = 0;
> > ccd979bdbce9fba Mark Fasheh                 2005-12-15  1806  	struct ocfs2_super *osb = OCFS2_SB(sb);
> > ccd979bdbce9fba Mark Fasheh                 2005-12-15  1807  
> > ccd979bdbce9fba Mark Fasheh                 2005-12-15  1808  	if (ocfs2_is_hard_readonly(osb))
> > 0737e01de9c411e Heming Zhao via Ocfs2-devel 2022-04-29 @1809  		goto out;
> > 
> > Unclear if this is an error path or a success path.  Honestly, I would
> > have thought the checker is correct that it looks like a failure path.
> > 
> This indicates a readonly mount and bypasses dlm related initialization.
> So it seems an expected success return.
> 

A comment would help.  Another way to silence this static checker warning
and answer any reviewer questions would be to set the "ret = 0;" within
4 lines of the goto.

	if (ocfs2_is_hard_readonly(osb)) {
		status = 0;
		goto out;
	}

regards,
dan carpenter


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
