# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

# frozen_string_literal: true

module ElasticAPM
  module Transport
    module Serializers
      # @api private
      class MetadataSerializer < Serializer
        def build(metadata)
          {
            metadata: {
              service: build_service(metadata.service),
              process: build_process(metadata.process),
              system: build_system(metadata.system),
              labels: build_labels(metadata.labels)
            }
          }
        end

        private

        def build_service(service)
          base =
            {
              name: keyword_field(service.name),
              environment: keyword_field(service.environment),
              version: keyword_field(service.version),
              agent: {
                name: keyword_field(service.agent.name),
                version: keyword_field(service.agent.version)
              },
              framework: {
                name: keyword_field(service.framework.name),
                version: keyword_field(service.framework.version)
              },
              language: {
                name: keyword_field(service.language.name),
                version: keyword_field(service.language.version)
              },
              runtime: {
                name: keyword_field(service.runtime.name),
                version: keyword_field(service.runtime.version)
              }
            }

          if node_name = service.node_name
            base[:node] = { name: keyword_field(node_name) }
          end

          base
        end

        def build_process(process)
          {
            pid: process.pid,
            title: keyword_field(process.title),
            argv: process.argv
          }
        end

        def build_system(system)
          {
            hostname: keyword_field(system.hostname),
            architecture: keyword_field(system.architecture),
            platform: keyword_field(system.platform),
            kubernetes: keyword_object(system.kubernetes)
          }
        end

        def build_labels(labels)
          keyword_object(labels)
        end
      end
    end
  end
end
