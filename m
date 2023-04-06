Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AECD6C7618D
	for <ocfs2-devel@archiver.kernel.org>; Thu,  6 Apr 2023 01:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=6ufNtT9gbSvVUw18Ab21IWiX9AWcViYhs6H2E2npVdk=;
 b=UiCsLfaOAEojcH+RQjlVPet5q4HK2bmi6/h3e8Jxz3xRYG7yUj+waEEWd5BUhmCP4AQjhwf4JVnX
   rkw6zjfw7MbSGT8C+N2WcJxaXQnIxKJv0ypdLPQXKLxwXbjsToDFtmP/H2DVvbIhyCG8uTz+Ryqx
   61QchrCpA85fAjhiwS8bgbRsa+0G6k03iiBW+u+SJ+cY9cPVPC0cVeUU3zAA4tqA3fleNnZjxi01
   kb1kmOD+85/KA7hmUbXR5pqo8UhmNgUCRtExD+vgsfrE3hXUqgQ1f/R9pKOtQD1RoMh8ZtJnemEy
   XnTfXYvZl2xidVBemRzIVWVjq5zrOwCgdB+RdA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=6ufNtT9gbSvVUw18Ab21IWiX9AWcViYhs6H2E2npVdk=;
 b=ByrEY1dGTL6j1/PiD+X/oetBgtu+BQAA2tBSM0vhH5bdnJ3M3pQUY/KKv9CogKXMLfuzKIbK3YXX
   5tFmPNQnEOlicx/7fb7p2V9hw7HLYyCe6h3OiSfOZ5j2uOA2JEnt6G1NarI2CMPNja2VD1WAmfYt
   xuPVleJEQMEM8TzR3QAjtRVb/sQPj5x+WUpgr2Zm916H/FrWtw+Q1LzwBqcQTz7hc1yY8rvAjkWv
   MWD2EtEAT+TEFpX2Yq4vGreRD01rE5SHuPZdSG+JuN3845tgX6XZEhz9DHgpIDD2xLS3rr6Ayrt2
   U8v36O353aR5OUE3bwUgjAS9LZ1vgbPdpEjbsg==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230317 64bit (built Mar 17
 2023))
 with ESMTPS id <0RSO001DD7XXB6B0@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 06 Apr 2023 01:53:57 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org; s=k20201202;
 t=1680746022; bh=RU0Q3vUCSoOriMTSmQ2CiAo6okbHQsDApEtyfqhB/os=;
 h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
 b=FbWqGQ0wbGurzrP9KVHM0SNw0YC9GyWApFTXwdNVcK2A0TiZtlGaba89nxCOMrOnv
 LWjeD76eOESSoHb3bjdBWreXKq9o6hYFzR7svS/T2cmmEB82GOCY4PQ4xwOErbFzpU
 hmcAghCKLKqbx4A0blihXUGzlq7+9VmymPLp1sU/9GKwTNgaMazWLz2aF2o38rqb3J
 b3LRiP0wTjMiqcG9t360E1ofmIBaOFnuhJb3uzgevc579iZR/wnVuIvdPxErd0uHqj
 plvf4gfX7jEtsbHb5zbnA4A6/Ie41UsiXOM4Khj5aTYqCMkOCJ9lIg3iiItz27lqAh
 KTIvUAvOE5HOQ==
Message-id: <b0214d14-aa0e-f1df-4ff3-02304b710a6e@kernel.org>
Date: Thu, 6 Apr 2023 09:53:36 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Content-language: en-US
To: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org
References: <20230404171411.699655-1-zlang@kernel.org>
 <20230404171411.699655-4-zlang@kernel.org>
In-reply-to: <20230404171411.699655-4-zlang@kernel.org>
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10671
 signatures=596816
Cc: linux-cifs@vger.kernel.org, brauner@kernel.org, linux-ext4@vger.kernel.org,
 ebiggers@google.com, amir73il@gmail.com, linux-nfs@vger.kernel.org,
 anand.jain@oracle.com, linux-unionfs@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-btrfs@vger.kernel.org, jack@suse.com, fdmanana@suse.com,
 ceph-devel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [f2fs-dev] [PATCH 3/5] fstests/MAINTAINERS: add
 supported mailing list
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
From: Chao Yu via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Chao Yu <chao@kernel.org>
Content-transfer-encoding: 7bit
Content-type: text/plain; charset="us-ascii"; Format="flowed"
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.kernel.org ~all
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-ORIG-GUID: 1BEFVy23VYGJzISyeTDf_spBiHQaRdJa
X-Proofpoint-GUID: 1BEFVy23VYGJzISyeTDf_spBiHQaRdJa
Reporting-Meta:
 AAGQgGFKyafxjD6iDfNr38RXM0O/WQRyty1l6LN+LgrUrZkgV8r18IYR2z64hz8Q
 fT/I3TaazhCZGwdNuzPp3bMgE6MOc81xEkPL+DnCNC0uRm6VoRbEGXFN4kY0Hwrf
 GB2VXJnUtlAurvJ1H9E4j+X34rCFcaJsiZEjrC8UkeUHNMG2dtX3PRmQcSx2qlpF
 0Bhqu8cdxkYkE5BoUT7Gv/MoBGpjESeAdDLZHU1utg393u+D79IQA0boVZf9zZHy
 6U7LWwpxrRc++Q8ZO0Z+JVRSaEbMwYLW4MuScDLOCmOfttFkDok0E+dyHbDDSRVW
 0VvtJBqV92C2EtKZ1QzpMSgY3UrJqlqlMLH3C1M5UEDSh1D1LSurU3yXIkd2dXxE
 T56+yR4qZYB4whyrk6SK2Y8JQEu4GQ4wdbvMTRSfDcGMY57AchEIeIHmTLyI9Bmv
 idSCRpXK4Xdf8WWRo3x35iMTcdO+/7jFLXKAvxSVvc9fnM+gcgKijATiQYWtX3vc
 iLhucHK3djjyPt/vvq30KLy2RgxEuPQAVBjrxiWQMm3V

On 2023/4/5 1:14, Zorro Lang wrote:
> +F2FS
> +L:	linux-f2fs-devel@lists.sourceforge.net
> +S:	Supported
> +F:	tests/f2fs/
> +F:	common/f2fs

Acked-by: Chao Yu <chao@kernel.org>

Thanks,

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
