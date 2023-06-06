Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 859DAC77B73
	for <ocfs2-devel@archiver.kernel.org>; Tue,  6 Jun 2023 13:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Yr2pxpoYtbqH2snciBI5Mp/QMPZtm2LBGZpRTsaA7I4=;
 b=Hn51FYSmkOUIEl+gT01Hx+7Wgfcq4Sh44kU5wgN5rw4Hx5+kBWeuy69jharw3GjWMdh0Doiio1xC
   ZPEEr1yF376lk7Jf2BarEdocypJHAEJ18Eg/vaznx4xhPsFz3jb6OvCP1/YMETc6VyBzu2Mn5NTG
   2WHWouNoFIbh6lXMpI+BIlE4d22hEVmIqUL+l9oO3Sbvt4bUQxzZ7R8Uo2queA/aTlhiUS5hG+AE
   T1Mei8qBBNEctAVP70OrUQBW9LTLi3RtYxhZWZWljJRzoQEZbJd+ifV1Z6AcHUKh96/GEx5IU/3e
   vEZegfpBFvg511GQklUgprV5qLdA2rGC5f/Jkw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Yr2pxpoYtbqH2snciBI5Mp/QMPZtm2LBGZpRTsaA7I4=;
 b=Fc5EGsJ8E2KVl003P3LaoKOIfAGummKt7Fn2lB/xkjFy3UB4AjFMSPmjjw6kdianMQotLy0lih1P
   QdD2fsfRv2Y1Kcv5zXJUtiRz0RFwbznJTfQPAp7kwLJIhiCiS2S0qdzE0z6a5z1tGomSxZlHJ2MT
   ooX1p2nZjbtlmWQ256mLmEt4intAOsy+fmuZ3PDgyoJgrtQ/ZWm8vYjLW28TzNU8fddehT+trc31
   N8C2Ua4VC+cgXNp1PKZ6eNVY+RXigbH1YRx1d+Tr8IGt1IEpGC3p+ZmYRboc1T3JAcziMPCMJbyi
   DXE/Aec5WdIkYCga5X/NsWH2jnM/FV2mECma8A==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RVU00HCX2WNJP40@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 06 Jun 2023 13:31:35 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 t=1686039783; x=1688631783;
 h=content-disposition:mime-version:message-id:subject:to:from:date
 :from:to:cc:subject:date:message-id:reply-to;
 bh=LFGlEMM2yEAI7uvBZUvgd9nVZbQPH0NX2rAZyLxDL/s=;
 b=sYTM+jirLUX3pn3acEUvfkKq0o9SYO1tBarg4JOhfHcOD9JvQZU83USCV/ymSbjrGy
 uISuqKCm8+LYnecahyC3tGh1dRA2D6yYO/PTuLKyvi3v4rHE35pQzkaoIN+IUgzJL6SI
 MOjPtnsNlAFl9OTAyyG1kv4RD1nF/Wcey8nD32V6m1UCeH/OzCdt1He1NV4JjR0PLDi2
 s0wAsmK8bclavYZ0YxCJIAmqCMHkM9KjnVvgP+zNAhi1t8tGRkdwRK3Zlz7QoneB5f7U
 H5nge7xuhnuOKfBL5FlFCUrvzJ2FICDBLMLK0sAaOxfaNA8Vb6/u5bASTZE1kE0w+fQJ mE4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20221208; t=1686039783; x=1688631783;
 h=content-disposition:mime-version:message-id:subject:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=LFGlEMM2yEAI7uvBZUvgd9nVZbQPH0NX2rAZyLxDL/s=;
 b=KWpXp5NICPaPAlLaNjypKKTTN4rBH0XJ9CrQIo5cskXMbyvnAPRKoyViYJs8lxRbVs
 JppOrGM839e9b/BnYpTjb5WxVzT5wu+uv9oy0+2tUFuFWhk/JA7W4aH+yZHeDk0EwqK8
 YTUG3NxFo1b7lHtXOw/SsHDHd60GHnrEvH+qnP6tvcUmp4Aa906m/QfbrLlVXO6Wv/HE
 lM5IDF1gJyGW4JMQXTAGuEKmmQfi+VUnua2GSFD+s1sWIpNEubjKuuRfumh0ot2cGOlW
 SamG2vFg+E/94h0ppguMqMvBuh7McYILBJ7oFZhXvvgkjf2guo9Plw3ogJvd6PAE0AiU y3sg==
X-Gm-Message-State: AC+VfDy3GVUVZD6cgpsbrroSkwjZKEOXjn75EhXcbEaZCKIrGE7skrlq
 CTAih8675wvSiNAXEqx9lPDN5ht/cmKtoS49P0k=
X-Received: by 2002:a7b:c850:0:b0:3f7:3a11:e3ae with SMTP id
 c16-20020a7bc850000000b003f73a11e3aemr1385148wml.38.1686039782868; Tue,
 06 Jun 2023 01:23:02 -0700 (PDT)
Date: Tue, 6 Jun 2023 11:22:57 +0300
To: ocfs2-devel@oss.oracle.com
Message-id: <ZH7s4RhMJUXzEeVV@moroto>
MIME-version: 1.0
Content-disposition: inline
X-Source-IP: 209.85.128.51
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10732
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 impostorscore=0 spamscore=0 phishscore=0 mlxlogscore=999 lowpriorityscore=0
 clxscore=118 mlxscore=0 malwarescore=0 suspectscore=0 priorityscore=261
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306060072 domainage_hfrom=4817
Subject: [Ocfs2-devel] [bug report] ocfs2/cluster: Pin/unpin o2hb regions
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
Reply-to: Dan Carpenter <dan.carpenter@linaro.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Google-Smtp-Source:
 ACHHUZ5cyF39UYDnk/jBUG7p3ikkTdJAulCOONBa0MK8XSqtfJubryA7UClwgGrylOqhDmDd4+fOFw==
X-ServerName: mail-wm1-f51.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:amazonses.com include:_spf.google.com
 ip4:213.146.141.112 ip4:144.76.223.100 ip4:82.71.243.203 ip4:107.21.238.147
 ip4:54.225.227.206 ip4:93.93.131.118 include:spf.mandrillapp.com
 include:servers.mcsv.net ~all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: YmiC_jinYOSgUIAp9lKD9DFJhojZlvqi
X-Proofpoint-GUID: YmiC_jinYOSgUIAp9lKD9DFJhojZlvqi
X-Mailman-Approved-At: Tue, 06 Jun 2023 13:31:31 +0000
Reporting-Meta:
 AAELv+jGVaaWt+hw5WMEFK90fxP0wKUy+z1/yjEtPop7FOYAqQoe/tY6khElVqzn
 8Z8ha3hUCEiOJdrhcn90PNs16X5KFuQCuiZl4jlfSaq03xFZXdnVj3CKjXlQraT8
 CcHC10dxMj/DiWxyOr3eGbNw8j0+ETJZIGWmnTDR2ImldsQH+FWbBcv3QlKJXIWH
 +fZj7gsQJdhOFIxUuu36dBGDT6TCr1DUVyvVAGx54SlhTqCXUd4CKX7oZy48eo7j
 Iyno0d71wkZhQPIp0AOZEJRI4+ND2N+KDOCvXxVr1ZlSgilU37pIitBAAsyltmpu
 ha2oTya4KRSi0mLaEDgGje9snt5qoaJNsG6r4cVG9eR5CiUY7k7biPo/dN9cLArI
 jCyJYVIg/52n1DsfUoY0gybJV08jO4ue9dXWL9PMEFzmAuZaMGveLACcQyZpO8z7
 exL1HxjdGssnQ7h4Y2m5TEo8yN8DP/+Vxy8Zj/lrAnRCnkSIUH8+oMhHKUSgivWN
 c3rYSo+9Q/6wM+/b6x0dD2jgyPRDI0/TJ9YjfDpqBIrHJg==

[ This is ancient code. - dan ]

fs/fs_context.c
    168 {
    169         int ret;
    170 
    171         struct fs_parameter param = {
    172                 .key        = key,
    173                 .type        = fs_value_is_flag,
    174                 .size        = v_size,
    175         };
    176 
    177         if (value) {
--> 178                 param.string = kmemdup_nul(value, v_size, GFP_KERNEL);
                                                                  ^^^^^^^^^^
Sleeping

    179                 if (!param.string)
    180                         return -ENOMEM;
    181                 param.type = fs_value_is_string;
    182         }
    183 
    184         ret = vfs_parse_fs_param(fc, &param);
    185         kfree(param.string);
    186         return ret;
    187 }


There are a couple OCFS functions which call this sleeping function
while holding a spinlock.

o2hb_heartbeat_group_drop_item() <- disables preempt
o2hb_region_inc_user() <- disables preempt
-> o2hb_region_pin()
   -> o2nm_depend_item()
      -> configfs_depend_item()
         -> configfs_pin_fs()
            -> simple_pin_fs()
               -> vfs_kern_mount()
                  -> vfs_parse_fs_string()


fs/ocfs2/cluster/heartbeat.c
  2338  static int o2hb_region_inc_user(const char *region_uuid)
  2339  {
  2340          int ret = 0;
  2341  
  2342          spin_lock(&o2hb_live_lock);

Lock.

  2343  
  2344          /* local heartbeat */
  2345          if (!o2hb_global_heartbeat_active()) {
  2346              ret = o2hb_region_pin(region_uuid);

This function starts the call tree to vfs_parse_fs_string().

  2347              goto unlock;
  2348          }
  2349  

regards,
dan carpenter

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
