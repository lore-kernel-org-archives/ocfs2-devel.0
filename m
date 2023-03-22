Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C694C6FD1F
	for <ocfs2-devel@archiver.kernel.org>; Wed, 22 Mar 2023 23:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=uSq4gUbk5yzNX4WXjcamkX4OQftT7gW8H9OF7jJIdzc=;
 b=YKNJpedjs014WqhtjsvN+a/9u7LuJ8heG5eROqVDzcnIzWHP5FyJE/MXxLhot80egNW9WteVmRy+
   ZjuPMEwqzGH0WAzKGUKPbKLySjVw7LyX1VDkwIshIOMRq3TjZr6TF6NxE6a3SBrnxe+5ANX0MzEh
   rEGS0DfptJdiIccLNAZacKJw+1y7QH4RBlusZhpj8I9Xkoa+NELoxwLf5YUMpx9e3F+pk+wt+dKS
   zPQMRmPv5L9rCTcSBiuQAjoTfApvMRewD0MnoNmjGEhX7e2uwibnnn/yi8X6RAuZDK28HkPs2xhv
   t+oEJ2Xo1aCBwdHcO8Y+TqNQCcG+7whHZW4hcA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=uSq4gUbk5yzNX4WXjcamkX4OQftT7gW8H9OF7jJIdzc=;
 b=tdquy1TL/qavlg7GFrAuFIDcJ6F5GP1Kl86Ot002Irg3U2wbVJD9gOVLxgLDLvHFyn0rfY7n35uB
   BHomozm0+fW1/0m+ko1Ogp5B/wSioHLiGi3eg4OP7rslwzDGs1Ui1jr72rkNqtFravsQ3YKJl7rL
   bGPtN6ZLjEUAsx1P2z70GGpBDKX0+5DGY3K0RC6vHQweEAIjUSjFdKl9zoOgQgTYfwy0l2sDWoy+
   g5Fruetn16xFifvoRa7n+d+tzLTXy1JAXsmXZzXYQpOjs+QON+W5vPhFvbtEyt0mUE0A7C52t51t
   tKjOAj9oK0w6DbQYPXCLDFpckAhip/Uc4SONkw==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRY00ONT4902L20@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 22 Mar 2023 23:36:36 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=wdc.com; i=@wdc.com;
 q=dns/txt; s=dkim.wdc.com; t=1679528183; x=1711064183;
 h=message-id:date:mime-version:subject:to:cc:references:
 from:in-reply-to:content-transfer-encoding;
 bh=09Qms904bOmUjhbXd6xEeHgGApY/+/dzqrMlIByjay8=;
 b=W3B0ISOv8z/F1eIJckoev0YY25ZeRnEVGCvu1aCXYNLnuzKwA6yqMNgx
 n69+PpTBhU80S7CG8AUeKjXb9r6uLEkGCo3883dYxspRp/b8/ySVjd+iC
 jc7VaAVtxyeaSlFIoLHis7pmiYssgct8jPIPKx6AtxQEVxOvIh4+Cpt93
 UQEUSdyKSbAFSx2TyZf1ROov8KneYNtRoQRjy2er6jZOstmgio1JdOw8Z
 nN/m//SYCmA7sHAt5K+VZ3a8AIKVK+3n7bNWLynhgUbYDt/bBwrA0Nlx6
 ttu4nKTximN31zymAJ4MdHRxSUUci7V2r6GylETfIXgiizUmrWRQuZrxE Q==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d= opensource.wdc.com;
 h=content-transfer-encoding:content-type
 :in-reply-to:organization:from:references:to:content-language
 :subject:user-agent:mime-version:date:message-id; s=dkim; t= 1679528180;
 x=1682120181; bh=09Qms904bOmUjhbXd6xEeHgGApY/+/dzqrM lIByjay8=;
 b=KtGmz/4s+WErFe0YDopct4p9SCgKWSBjkf/v0LXVqpvIE7Cp97I
 HwUjAw1+w7quI27Y62BMUUcCK0OV5tPUUdDtK6IQW8fE8UeEryVZvG4mnLJOydCl
 jenTd/nd2h43CSxEVZlySJHOJ7x1asdj830YIOjJOEtD5u8vPE9gkos7uXnOO/Yy
 iQQo2zQMMOy1TNql00nYf3eO4t7c2XJImsYGHPIwiWx518ull3cXfVg6Y2QzL0k4
 tNnUmeh1UKgneidCUOku6Z07zNSqNxWoerMSUfGkTFDaZISoL+x+2kAivAEYxnlo
 1KPMFAkGgyFT2yeOjFFTCzbLZLr4kYsZSWg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Message-id: <1ca2125b-0e05-0ae9-3921-9b397732bc9c@opensource.wdc.com>
Date: Thu, 23 Mar 2023 08:36:18 +0900
MIME-version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Content-language: en-US
To: Yangtao Li <frank.li@vivo.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20230322165905.55389-1-frank.li@vivo.com>
 <20230322165905.55389-7-frank.li@vivo.com>
Organization: Western Digital Research
In-reply-to: <20230322165905.55389-7-frank.li@vivo.com>
X-Source-IP: 216.71.154.45
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10657
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 adultscore=0 malwarescore=0 priorityscore=235 suspectscore=0 mlxlogscore=952
 clxscore=174 lowpriorityscore=0 mlxscore=0 spamscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303220172 domainage_hfrom=11268
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
 "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [Ocfs2-devel] [PATCH v3 08/10] ocfs2: convert to
	kobject_del_and_put()
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
From: Damien Le Moal via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-IronPort-AV: E=Sophos;i="5.98,283,1673884800"; d="scan'208";a="226273294"
X-ServerName: esa6.hgst.iphmx.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 exists:%{i}.spf.hgst.iphmx.com
 ip4:199.255.45.14/32 ip4:199.255.45.15/32 -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: 1SKwfAiFYlMvdDquGg2pCLrUbNCtQV84
X-Proofpoint-GUID: 1SKwfAiFYlMvdDquGg2pCLrUbNCtQV84
Reporting-Meta:
 AAH5c+JElEAI1nfyOABfv2eNfY6mNTRSpq0Fv6YjH0DLQ7Veq5ledJvx6kpcMFSf
 U2IN1c33QL4aceA4ApSRzkpiPwMK7sg0ceGRWoz3CavsqdHu/KeBfLfthYEMRcEZ
 zmDZpyui+ab3XI4OSPDGDWkTZ/a0OKcjXLVt150F88cKSXmkjQRa9WoyZPZuodY4
 q8pL/07G1qIPO9nwZSvow08x9Dc1HoYLVdsgV4qEV97Cgu6LLnaB0PFlXuC/vc7L
 RMGtLNJYy543Eel3ksamwjMBQCsMeEo+bo9RJ8aYVUPaTuxffJoeepCJTwi6QePZ
 bb7kXH5g0Mr0bq5wS1TJch++77QrECvqXESAkfZyz9rYnZQWRuyjy2oHjDjt2Bw6
 MkIBL7pHAGNTJs/t9Q9oqVGDrNeMHyqHJIjRVgYmNfKQyQu33V1oqxF4MpwJkKbh
 ca1rM3UDRObjfFGOUGX8vZdZJ1eXQrsaW4vfJC6r8Lc93VOCfXAquZqdsHC03Td+
 a7/zdvF2FTYieK/vZTq+ZNa9Tr7oGk7jPG9c9UKi/ToG
IronPort-SDR:
 XdN+oW4VeCuS6p37Nzbw9074fv1nB66LHQ8duY6Hjr3Abzmdm2tsONLOrZn21fMKw702xTkm3r
 Y4g6y0t/o4uFoQ/AQgw64L/EqYtkndORe3yhOC77vd1PDfnq0AVO3h7JX/k6U7L5hw5GO8LYLt
 CWUoh85Iamh1wP61K8mw+I/JIbOuKkOHN1yL9921ceztHJUSCin8bprRfqF26ZXIejRO9RBoBB
 ncgLMohpd2rU4sETUszQe7m9euPf6gNzqkxfphxjTePb+1pD0FCsf4Wgo2VW+u5XMGFKuaFtpL bPg=
IronPort-SDR:
 R+77s0z6iBBzcmWAeCSDnUlA0anowpjI0/XpHKf8GQJ3n+OOAWbA/2CWDbPvPRAa1FBzQnmTxY
 Tcqv1vTOrrDedeB40ncPa5KvjVU+a57eM5WPmRapEtWyzlfkC3z3kk2rCKjRsoGgKh33V8fKDY
 B70XYr5jfHMnqCa/qwvnxMntfrw/xEHtZcJPzV/ZZjArDntjxYASrTxXZ9qVL719vkS9O3LMDb
 F4erbRHxAYmSMiEaexc900pDV2qq5s48k9BBQg+XrBhvRKwdThPoa6luJgh3KYVsg7BzVDgTS6 Ovs=
WDCIronportException: Internal

On 3/23/23 01:59, Yangtao Li wrote:
> Use kobject_del_and_put() to simplify code.
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Signed-off-by: Yangtao Li <frank.li@vivo.com>

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>


-- 
Damien Le Moal
Western Digital Research


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
