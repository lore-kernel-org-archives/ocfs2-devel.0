Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB027C433FE
	for <ocfs2-devel@archiver.kernel.org>; Tue, 22 Nov 2022 08:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=r2LxDUb9muk76qT7SAEoj3wq0BH6GwL90eh14NRTEgU=;
 b=lQILISEfpy61X2/Z8uK0btSlD86h2goABtbEMsUBkHyqv0+SefeWKpdpgRaWrCYQgHBhhNUPdaSc
   dPfReYUo3/3mXtx79gMHZJOM7dFHZsn4oIxnFjYliacRcs5CcUXthi39CVLx4N+ZA9PsNyOdcN6z
   Ox3MZ10ZWtFC4RtrRJnCuJKYl3DBlTysGSvr6UBLi9o8ufg5hWT77I57W92DTfo+tMQJHHZ0CzJd
   E7Jz8G3jVgx3he8nm++wcmUfp8M4obiAwk5RqKGPBpBGuAo0m6yWvLFolScJ0Bozc7prw7db9sxn
   iWP5Q5KO0sjQVMA25Jw7HteNyBThmQTtIOiBVA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=r2LxDUb9muk76qT7SAEoj3wq0BH6GwL90eh14NRTEgU=;
 b=qYIY4UDeUY4pHUPRrp0aLXyay7XuoEZeIIBkduK59TaIdT+dG/V9BaMMmqk/nbwvils8kkEgqiIt
   hogbCoEYxiOG1HbB5CAhcYzyLXdsGL+3xQZyAExTmqHmecwLlxxUMJFf0g9+IQ+pJYqIY3D/sdrs
   1Sc6wN503V4cGhO1NFeag689lBykFd8CWN8wMSbhSM4pJAdXGvuqq7cT8a9ZGBiR93XQFuLUmd83
   i9DRVyTItSj6q9PsVkITA3Y9zvTUJ3mijUxgHO/uZTGuO0g76zXCylxb4nTF50KgxoQ0lq/t6/Ar
   vydfVGGPePstoCvuwSX50il9/OW3eloBVVkObw==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RLQ0040HQAYLOC0@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 22 Nov 2022 08:30:34 +0000 (GMT)
Message-id: <339eff96ebcd4c7ecba2ed56751fd2636fa52f73.camel@huaweicloud.com>
To: Paul Moore <paul@paul-moore.com>, Mimi Zohar <zohar@linux.ibm.com>
Date: Tue, 22 Nov 2022 09:29:40 +0100
In-reply-to:
 <CAHC9VhTvcgOjXAH51Vnk66kEjXfjUS2aJjXjJmU-rwLT53vWPw@mail.gmail.com>
References: <20221110094639.3086409-1-roberto.sassu@huaweicloud.com>
 <20221110094639.3086409-3-roberto.sassu@huaweicloud.com>
 <3dc4f389ead98972cb7d09ef285a0065decb0ad0.camel@linux.ibm.com>
 <aa5fa8c5f231115c58012352124df57d16a01e41.camel@huaweicloud.com>
 <7812899531b2bd936b25fde8fc2f1c2a6080b2bd.camel@linux.ibm.com>
 <CAHC9VhTvcgOjXAH51Vnk66kEjXfjUS2aJjXjJmU-rwLT53vWPw@mail.gmail.com>
User-Agent: Evolution 3.36.5-0ubuntu1
MIME-version: 1.0
X-Source-IP: 14.137.139.23
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10538
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 priorityscore=48
 malwarescore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 impostorscore=0
 adultscore=0 spamscore=0 phishscore=0 clxscore=57 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211220062
Cc: nicolas.bouchinet@clip-os.org, keescook@chromium.org,
 selinux@vger.kernel.org, dmitry.kasatkin@gmail.com,
 stephen.smalley.work@gmail.com, Roberto Sassu <roberto.sassu@huawei.com>,
 jmorris@namei.org, reiserfs-devel@vger.kernel.org,
 linux-security-module@vger.kernel.org, ocfs2-devel@oss.oracle.com,
 casey@schaufler-ca.com, eparis@parisplace.org,
 linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, serge@hallyn.com
Subject: Re: [Ocfs2-devel] [PATCH v4 2/5] security: Rewrite
 security_old_inode_init_security()
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
X-CM-TRANSID: GxC2BwAnDvp5iHxjEJiEAA--.54837S2
X-Coremail-Antispam: 1UD129KBjvJXoWxXF4rArykWFWxtF17tF4Dtwb_yoW5XFWrpr
 WfKF1UKrn5JFWDCr4xtwsxWF4Ig3yfGFZxXrn5GrWUAr1DCF1xKr4jyF13u345JrWkJ3y0
 qw4xZ3y3Zrn8AwUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAQAEBF1jj4WyCQABsP
X-CFilter-Loop: Reflected
X-ServerName: frasgout11.his.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.51 ip4:45.249.212.56
 ip4:185.176.79.53 ip4:14.137.139.23 ip4:14.137.139.154 ip4:14.137.139.46
 ip4:124.71.93.99 ip4:124.71.93.112 ip4:124.71.94.104
 include:spf.saas.huaweicloud.com -all
X-Spam: Clean
X-Proofpoint-GUID: GTH9_0TElZXnATeRcZ2yrlJPJudRXK_8
X-Proofpoint-ORIG-GUID: GTH9_0TElZXnATeRcZ2yrlJPJudRXK_8
Reporting-Meta:
 AAHadbcXiforXsiu0DFjvPkkbI8VRWz4EOXC6XbGTsnIgJjuYh83TKQpwM5GoWz3
 vEG42OSxqAfOrfuxXq8WXHOFWxGXL8BHh5/9kqbkLmCKERmQ7NllbxkJ/t5yamB6
 AJwzk2l1B+MYMYiPzJ9/8OuV2vV3cbrfYiKxzA8HOfdv1GuD2BkbvxgZ9GNlJpKV
 k3Neh/BXqcNJ4TO89nRemHrR569NtL/SnXvsQjqZDzo8K/vXk5LNLmmkq/e2ETSL
 Sp01H0FajP6I6XeOeQl8dIzRVO9dsU5M2zMiX2xat3eQbKeXIcBKmb7jbJRh8QHI
 63oEzQ5KBUeBS4mZiRW54ssKa+Im0hoR1G8jbP58NogyXpocsFNI2qWereOtywjv
 DBq4/MTFqIF06ooI1F7wgB09Hy0QhLFertFYyWYMo8uhDcJqF3iQlH4n6rNthClm
 j8cvnMU9Y0AS0InZpP+PPS7q38vpeCb6tIEJRSKC+zOyJQqF4PHWE4r/j9yaX4Fq
 UmsCXw9GPwPuPwjkdFlTR+jk5xpTe8ATFKs+RFQ6LZxXnQ==

On Mon, 2022-11-21 at 18:55 -0500, Paul Moore wrote:
> On Mon, Nov 21, 2022 at 3:54 PM Mimi Zohar <zohar@linux.ibm.com> wrote:
> > On Mon, 2022-11-21 at 10:45 +0100, Roberto Sassu wrote:
> > > > As ocfs2 already defines initxattrs, that leaves only reiserfs missing
> > > > initxattrs().  A better, cleaner solution would be to define one.
> > > 
> > > If I understood why security_old_inode_init_security() is called
> > > instead of security_inode_init_security(), the reason seems that the
> > > filesystem code uses the length of the obtained xattr to make some
> > > calculations (e.g. reserve space). The xattr is written at a later
> > > time.
> > > 
> > > Since for reiserfs there is a plan to deprecate it, it probably
> > > wouldn't be worth to support the creation of multiple xattrs. I would
> > > define a callback to take the first xattr and make a copy, so that
> > > calling security_inode_init_security() + reiserfs_initxattrs() is
> > > equivalent to calling security_old_inode_init_security().
> 
> FWIW, reiserfs isn't going to be removed until 2025, I'm hopeful we
> can remove the IMA/EVM special cases before then :)

Well, we are not that far...

> > > But then, this is what anyway I was doing with the
> > > security_initxattrs() callback, for all callers of security_old_inode_i
> > > nit_security().
> > > 
> > > Also, security_old_inode_init_security() is exported to kernel modules.
> > > Maybe, it is used somewhere. So, unless we plan to remove it
> > > completely, it should be probably be fixed to avoid multiple LSMs
> > > successfully setting an xattr, and losing the memory of all except the
> > > last (which this patch fixes by calling security_inode_init_security()).
> 
> I would much rather remove security_old_inode_init_security() then
> worry about what out-of-tree modules might be using it.  Hopefully we
> can resolve the ocfs2 usage and get ocfs2 exclusively on the new hook
> without too much trouble, which means all we have left is reiserfs ...
> how difficult would you expect the conversion to be for reiserfs?

Ok for removing security_old_inode_init_security().

For reiserfs, I guess maintaining the current behavior of setting only
one xattr should be easy. For multiple xattrs, I need to understand
exactly how many blocks need to be reserved.

> > > If there is still the preference, I will implement the reiserfs
> > > callback and make a fix for security_old_inode_init_security().
> > 
> > There's no sense in doing both, as the purpose of defining a reiserfs
> > initxattrs function was to clean up this code making it more readable.

The fix for security_old_inode_init_security(), stopping at the first
LSM returning zero, was to avoid the memory leak. Will not be needed if
the function is removed.

Roberto


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
