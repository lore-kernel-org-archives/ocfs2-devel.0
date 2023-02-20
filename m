Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CAEBC636CC
	for <ocfs2-devel@archiver.kernel.org>; Mon, 20 Feb 2023 09:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=c/GBM6jvetm+8fvRKx8nqHdZh9ox1tbF+RziVjGIsJo=;
 b=iH0d8sxRGLOE/h5iKF8GhauLlAivnmvDovxwb0LhWJoGzITwCVhT8Dlr7ZUTXvZWnFlZeHMt8c2R
   FYBgn6CdTLJ3dPUW+80KtasKDgTUOfzrAX3s9HixF7x5Vhh4d0JUVfqeo1p/C96KMBgrTxvPSn8g
   I7vH7yHAjBKD3mSsUWhZLDh+qnJ4j5YsT6vXzl3PW1vPVLK60ZhC9c+nrETTW3ybwbxTOZDojYik
   lGbwhBf7up4ObJtszvyNdR8w9Z01nqDjUdG5Bmqq8nQsfRLq03Iogn0A+csrTYZO27ppTa8RETeH
   MaKesXyWXLj9w0m9PfBujtd2kXj1HhbICTg+kA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=c/GBM6jvetm+8fvRKx8nqHdZh9ox1tbF+RziVjGIsJo=;
 b=SLrpSOnBm/4jiiI+YDGbDscVrhHV4cyUbt0eCuKo9I6VREiyl4zxU+VTZBcv6Dv+3Ql5vKw6LUKq
   vMQ4CFkRoFUn3dwz0Ew0o722ZDOMm6icDWCqQotL0C9muM2Nx9Kk4vFwhsIgcWd/ZLdFvS4YFx3Z
   hQST/Igegl0DTVWUT48lbAlPBdaZUjvyOatrmTYo1Imhz9kxH8hC5uX+A1caNLetJlvxsiwsTXmx
   pXKpsjoBJbHPDNhcxtyUTEYjHLYADZ8BcqQDAHkwMoL6Mnn+Gc0sui4N8Yj58ulkREUSEtkrDEgZ
   zG7uXX1kue0MqZaMNL+DZk7Uu+y3iVIj9oO1PA==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230206 64bit (built Feb  6
 2023))
 with ESMTPS id <0RQD000R5I0BK8A0@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 20 Feb 2023 09:50:35 +0000 (GMT)
Message-id: <ab9245bfb43b96fd8eded8a4ca25f5cae20b9f04.camel@huaweicloud.com>
To: Mimi Zohar <zohar@linux.ibm.com>, mark@fasheh.com, jlbec@evilplan.org,
 joseph.qi@linux.alibaba.com, dmitry.kasatkin@gmail.com, paul@paul-moore.com,
 jmorris@namei.org, serge@hallyn.com, stephen.smalley.work@gmail.com,
 eparis@parisplace.org, casey@schaufler-ca.com
Date: Mon, 20 Feb 2023 10:49:37 +0100
In-reply-to: <1f252850086a39e3c15736f252600d388f6b9c24.camel@linux.ibm.com>
References: <20221201104125.919483-1-roberto.sassu@huaweicloud.com>
 <20221201104125.919483-7-roberto.sassu@huaweicloud.com>
 <1f252850086a39e3c15736f252600d388f6b9c24.camel@linux.ibm.com>
User-Agent: Evolution 3.36.5-0ubuntu1
MIME-version: 1.0
X-Source-IP: 14.137.139.46
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10626
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 spamscore=0 impostorscore=0
 suspectscore=0 clxscore=199 mlxscore=0 adultscore=0 lowpriorityscore=0
 priorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302200088
Cc: nicolas.bouchinet@clip-os.org, keescook@chromium.org,
 selinux@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
 reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v7 6/6] evm: Support multiple LSMs	providing
 an xattr
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
From: Roberto Sassu via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Roberto Sassu <roberto.sassu@huaweicloud.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-CM-TRANSID: LxC2BwC3QAw4QvNjBIw5AQ--.54153S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Aw4rGr45WF1DGr1xKF4xtFb_yoW8GrWDpF
 WfG3W2vF1kJF1xGry3ZayxZayfKrW8Gr43Xws0yw15ArnxCr1akrySkF43uFyUurWUJasY
 va1jkFnxZ3Z8Aa7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUk0b4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
 6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
 vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
 xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxV
 AFwI0_Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
 x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
 0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IYc2Ij
 64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
 8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE
 2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42
 xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv
 6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUFDGOUUUUU
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAgAOBF1jj4UwqgABsn
X-CFilter-Loop: Reflected
X-ServerName: frasgout13.his.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.51 ip4:45.249.212.56
 ip4:185.176.79.53 ip4:14.137.139.23 ip4:14.137.139.154 ip4:14.137.139.46
 ip4:124.71.93.99 ip4:124.71.93.112 ip4:124.71.94.104
 include:spf.saas.huaweicloud.com -all
X-Spam: Clean
X-Proofpoint-GUID: 7_ABevcpuAdBfyPw5lw2c-WoI9JGeGJO
X-Proofpoint-ORIG-GUID: 7_ABevcpuAdBfyPw5lw2c-WoI9JGeGJO
Reporting-Meta:
 AAFVOjKO2mfRMJUlhuifO6e2bDwWR3OlbCriS+8E5PDEb2/IiEilW9Gykzak5syy
 hPfI5abun88R8ahd+cfVL6SfNNPdYalMh11wtUOw5jQQyI3i9XfvCnJfMK8KPzrg
 YO7MX1GQJhGwrfXu71e95wvy+1o4SfYT2nxYw33O+i6z1yZCOYMjg5xeAEtYwzLA
 6vut+2wO6q7Yb8EHOjVHr6v9WUVwWKTe9pvTTiN4LME0JsE3e0UH23cB2Ecd0EF0
 Ztxa9C/llkghMEIZqUiv+XUlNPQdHRHUE+Gwz2llliztOsM87CmKg+xqBOQMIH0+
 TdTzQKEP0cMHpgFQROOE7wismEud1oAiNib/zMutLdPh5mJb/lPhHExUax+bJveO
 tqu/jYrVS2+9BiOIKP/vpyaQ6uP3MMt2w6RgI/JEzRtVjlAC8DFHXMBv7FiFRCTB
 +aZ2Jic+v03JMa4WDmm9tymEcP1zS9AuLUhiVLaXQKu0+oeEU/VikQPOLOlGkSzq
 fS2TxL9IwK9uE2+PuHPIPoMVh718UNwZKpA4fh0CJdTd

On Sun, 2023-02-19 at 14:42 -0500, Mimi Zohar wrote:
> On Thu, 2022-12-01 at 11:41 +0100, Roberto Sassu wrote:
> > From: Roberto Sassu <roberto.sassu@huawei.com>
> > 
> > Currently, evm_inode_init_security() processes a single LSM xattr from
> > the array passed by security_inode_init_security(), and calculates the
> > HMAC on it and other inode metadata.
> > 
> > Given that initxattrs() callbacks, called by
> > security_inode_init_security(), expect that this array is terminated when
> > the xattr name is set to NULL, reuse the same assumption to scan all xattrs
> > and to calculate the HMAC on all of them.
> > 
> > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> > Reviewed-by: Casey Schaufler <casey@schaufler-ca.com>
> 
> Normally changing the contents of the EVM HMAC calculation would break
> existing systems.  Assuming for the time being this is safe, at what
> point will it affect backwards compatability?  Should it be documented
> now or then?

Actually, the current patch set continues to fullfill user space
expectation on the EVM behavior. If the LSM infrastructure created more
xattrs and EVM calculated the HMAC on just one, there would be a
problem on subsequent xattr operations and on IMA verification.

By updating both the LSM infrastructure and EVM to support multiple
xattrs, everything will continue to work.

Thanks

Roberto


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
